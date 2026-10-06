import Foundation

extension JSONDecoder {
    static var iso8601: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            for format in ["yyyy-MM-dd'T'HH:mm:ssZZZZZ", "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ", "yyyy-MM-dd"] {
                formatter.dateFormat = format
                if let date = formatter.date(from: str) { return date }
            }
            throw DecodingError.dataCorruptedError(in: container,
                debugDescription: "Cannot decode date: \(str)")
        }
        return decoder
    }
}
