import Foundation

struct Activity: Codable, Equatable {
    let id: String
    let date: String
    let time: String
    let category: Category
    let title: String
    let notes: String?
    let createdAt: String

    enum Category: String, Codable, CaseIterable {
        case meal    = "MEAL"
        case nap     = "NAP"
        case outdoor = "OUTDOOR"
        case indoor  = "INDOOR"
        case other   = "OTHER"

        var displayName: String {
            switch self {
            case .outdoor: return "外遊び"
            case .meal:    return "ご飯"
            case .indoor:  return "内遊び"
            case .nap:     return "お昼寝"
            case .other:   return "その他"
            }
        }
    }
}
