import Foundation

struct ActivityResponse: Decodable {
    let id: String
    let date: String
    let time: String
    let category: String
    let title: String
    let notes: String?
    let createdAt: String

    func toDomain() -> Activity? {
        guard let category = Activity.Category(rawValue: category) else { return nil }
        return Activity(
            id: id,
            date: date,
            time: time,
            category: category,
            title: title,
            notes: notes,
            createdAt: createdAt
        )
    }
}
