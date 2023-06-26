import Foundation

struct Event {
    var startDate: Date
}

struct Calendar {
    // INVARIANT: sorted by start date
    var events: [Event] = []
}
