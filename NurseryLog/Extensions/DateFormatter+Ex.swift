import Foundation

extension DateFormatter {
    private static let japWeekdaySymbols = ["日", "月", "火", "水", "木", "金", "土"]

    static func with(format: String, weekdaySymbols: [String]? = nil) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        if let shortWeekdaySymbols = weekdaySymbols {
            formatter.shortWeekdaySymbols = shortWeekdaySymbols
        }
        return formatter
    }
}

// MARK: - ISO8601

extension DateFormatter {
    static var ISO8601Date: DateFormatter {
        with(format: "yyyy-MM-dd")
    }

    static var ISO8601DateTime: DateFormatter {
        with(format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }

    static var ISO8601DateHHmm: DateFormatter {
        with(format: "yyyy-MM-dd HH:mm")
    }
}

// MARK: - Display

extension DateFormatter {
    static var japYearMonthDayWeekdayTime: DateFormatter {
        with(format: "yyyy年MM月dd日(EEE) HH:mm", weekdaySymbols: DateFormatter.japWeekdaySymbols)
    }

    static var japYearMonthDayWeekday: DateFormatter {
        with(format: "yyyy年MM月dd日(EEE)", weekdaySymbols: DateFormatter.japWeekdaySymbols)
    }

    static var japYearMonthDayTime: DateFormatter {
        with(format: "yyyy年MM月dd日 HH:mm")
    }

    static var clock: DateFormatter {
        with(format: "HH:mm")
    }
}
