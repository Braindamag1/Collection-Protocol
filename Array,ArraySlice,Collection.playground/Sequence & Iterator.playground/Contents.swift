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


let randomSequence = AnySequence({ReadRandom()})
randomSequence.prefix(10).map({print($0)})

// sequence doesn't have notion of index

