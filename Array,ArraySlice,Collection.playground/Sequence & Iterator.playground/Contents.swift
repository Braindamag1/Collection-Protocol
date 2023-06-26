import Foundation

final class ReadRandomVersion_1 {
    let handle = FileHandle(forReadingAtPath: "/dev/urandom")! // an infinitely large file

    deinit {
        handle.closeFile()
    }

    func getByte() -> UInt8 {
        let data = handle.readData(ofLength: 1)
        return data[0]
    }
}

let randomSource = ReadRandomVersion_1()
randomSource.getByte()

final class ReadRandom: IteratorProtocol {
    let handle = FileHandle(forReadingAtPath: "/dev/urandom")!

    deinit {
        handle.closeFile()
    }

    func next() -> UInt8? {
        let data = handle.readData(ofLength: 1)
        return data.first
    }
}

let randomSequence = AnySequence({ ReadRandom() })

// sequence doesn't have notion of index

extension Sequence {
    func split(batchSize: Int) -> AnySequence<[Iterator.Element]> {
        return AnySequence {
            return AnyIterator {
                var batch: [Iterator.Element] = []
                var iterator = self.makeIterator()
                while batch.count < batchSize, let elment = iterator.next() { // while let 也可以解包，头一次看到
                    batch.append(elment)
                }
                return batch.isEmpty ? nil : batch
            }
        }
    }
}

randomSequence.split(batchSize: 3).prefix(4)

// randomSequence.split(batchSize: 3).map { "\($0)" } // runs indefinitely
// This happens because the return type of map is an array, and arrays always have all their elements precomputed.

let a = randomSequence.split(batchSize: 3).lazy.map({"\($0)"})
