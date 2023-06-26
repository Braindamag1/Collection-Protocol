import Foundation

struct Event {
    var startDate: Date
}

struct Calendar {
    // INVARIANT: sorted by start date
    var events: [Event] = []
}

struct SortedArray<Element> {
    var elements: [Element]
    let areIncreasingOrder: (Element, Element) -> Bool
    // implementation 1
    mutating func insert(_ element: Element) {
        elements.append(element)
        elements.sort(by: areIncreasingOrder)
    }

    // initial state
    init<S: Sequence>(unsorted: S,
                      areIncreasingOrder: @escaping (Element, Element) -> Bool) where Element == S.Iterator.Element {
        elements = unsorted.sorted(by: areIncreasingOrder)
        self.areIncreasingOrder = areIncreasingOrder
    }
}

var sorted = SortedArray(unsorted: [1, 4, 3, 2], areIncreasingOrder: <)
sorted.insert(-1)

extension SortedArray: Collection {
    var startIndex: Int {
        elements.startIndex
    }

    var endIndex: Int {
        elements.endIndex
    }

    subscript(index: Int) -> Element {
        elements[index]
    }

    func index(after i: Int) -> Int {
        elements.index(after: i)
    }
    
}

// Collection
for x in sorted {
    print(x)
}


extension SortedArray {
    func min()->Element? {
        elements.first
    }
}

extension SortedArray where Element: Comparable {
    init<S:Sequence>(unsorted:S) where S.Iterator.Element == Element {
        self.init(unsorted: unsorted, areIncreasingOrder: <)
    }
}
