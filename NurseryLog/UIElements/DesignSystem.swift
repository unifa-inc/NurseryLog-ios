import UIKit

enum DesignSystem {

    enum Color {
        static let primary = UIColor(red: 0.749, green: 0.925, blue: 0.941, alpha: 1.0)
        static let primaryText = UIColor.black.withAlphaComponent(0.7)
        static let background = UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1.0)
        static let surface = UIColor.white
        static let navBar = UIColor.white
        static let textPrimary = UIColor(red: 0.15, green: 0.15, blue: 0.20, alpha: 1.0)
        static let textSecondary = UIColor(red: 0.50, green: 0.50, blue: 0.55, alpha: 1.0)
        static let tagBorder = UIColor(red: 0.82, green: 0.84, blue: 0.87, alpha: 1.0)
        static let tagText = UIColor.black.withAlphaComponent(0.7)
        static let tagSelectedBackground = primary
        static let tagSelectedText = UIColor.black.withAlphaComponent(0.7)
        static let inputBorder = UIColor(red: 0.82, green: 0.84, blue: 0.87, alpha: 1.0)
        static let timeBoxBorder = UIColor(red: 0.75, green: 0.78, blue: 0.82, alpha: 1.0)
        static let categoryBadgeBackground = UIColor(red: 0.88, green: 0.93, blue: 0.96, alpha: 1.0)
        static let categoryBadgeText = UIColor(red: 0.30, green: 0.45, blue: 0.60, alpha: 1.0)
        static let pickerAction = primary
    }

    enum Font {
        static let navigationTitle = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let cellDate        = UIFont.systemFont(ofSize: 12, weight: .regular)
        static let cellTitle       = UIFont.systemFont(ofSize: 15, weight: .semibold)
        static let cellNote        = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let sectionHeader   = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let label           = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let timeDisplay     = UIFont.systemFont(ofSize: 20, weight: .regular)
        static let tagLabel        = UIFont.systemFont(ofSize: 13, weight: .regular)
        static let emptyStateText  = UIFont.systemFont(ofSize: 14, weight: .regular)
        static let buttonTitle     = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let notesCounter    = UIFont.systemFont(ofSize: 11, weight: .regular)
    }

    enum Layout {
        static let cornerRadiusCard: CGFloat   = 12
        static let cornerRadiusButton: CGFloat = 10
        static let cornerRadiusInput: CGFloat  = 8
        static let cornerRadiusTag: CGFloat    = 14
        static let cornerRadiusAddActivityButton: CGFloat = 28
        static let cardPadding: CGFloat        = 16
        static let screenHorizontalInset: CGFloat = 16
        static let cellSpacing: CGFloat        = 8
        static let addActivityButtonSize: CGFloat = 56
    }
}
