import Foundation
@testable import NurseryLog

extension Activity {
    static func stub(
        id: String = UUID().uuidString,
        date: String = "2024-06-10",
        time: String = "09:00",
        category: Category = .indoor,
        title: String = "Test Activity",
        notes: String? = nil,
        createdAt: String = "2024-06-10T09:00:00+09:00"
    ) -> Activity {
        Activity(id: id, date: date, time: time, category: category,
                 title: title, notes: notes, createdAt: createdAt)
    }
}
