import Foundation

// 1. sometimes return a slice, that's maybe a little confusing
let tempArr = [1, 2, 3, 4, 5, 6]
tempArr.suffix(2)

extension Array {
    func splitVersion_1(batchSize: Int) -> [[Element]] {
        var result: [[Element]] = []
        for index in stride(from: startIndex, to: endIndex, by: batchSize) { //that is, the position one greater than the last valid subscript argument.
            let end = Swift.min(count, index + batchSize) // collection协议中也有min 函数
            result.append(Array(self[index ..< end]))
        }
        return result
    }
}

tempArr.splitVersion_1(batchSize: 5)

// split not work on slice right now

// slice can not refer start from 0, end on count -- use startIndex and endIndex

extension ArraySlice {
    func splitVersion_1(batchSize: Int)->[[Element]] {
        var res:[[Element]] = []
        for index in stride(from: startIndex, to: endIndex, by: batchSize) {
            let end = Swift.min(endIndex, index + batchSize)
            res.append(Array(self[index..<end]))
        }
        return res
    }
}

extension Array {
    func splitVersion_2(batchSize: Int)->[[Element]] {
        self[startIndex..<endIndex].splitVersion_1(batchSize: batchSize)
    }
}

tempArr.splitVersion_2(batchSize: 4)

// use collection, slice and array both comply with collection
extension Collection where Index == Int {
    func splitVersion_3(batchSize: Int)-> [SubSequence] {
        var res:[SubSequence] = []
        for index in stride(from: startIndex, to: endIndex, by: batchSize) {
            let end = Swift.min(endIndex, index + batchSize)
            res.append(self[index..<end])
        }
        return res
    }
}
extension Collection {
    // index not int so can use stride
    func split(batchSize: Int)-> [SubSequence] {
        var remainerIndex = startIndex
        var res:[SubSequence] = []
        while remainerIndex < endIndex {
            let batchEndIndex = index(remainerIndex, offsetBy: batchSize, limitedBy: endIndex) ?? endIndex //O(1) if the collection conforms to RandomAccessCollection; otherwise, O(k), where k is the absolute value of distance.
            res.append(self[remainerIndex..<batchEndIndex])
            remainerIndex = batchEndIndex
        }
        return res
    }
}
    
tempArr.split(batchSize: 5)

"hello world".split(batchSize: 2).map { String($0) }
