import Foundation

struct ActivitiesListParameters: Encodable {
    let date: String
}

struct ActivityCreateParameters: Encodable {
    let id: String
    let date: String
    let time: String
    let category: String
    let title: String
    let notes: String?
    let createdAt: String
}
