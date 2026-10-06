import UIKit

final class ActivityCell: UITableViewCell {
    static let reuseIdentifier = "ActivityCell"

    @IBOutlet private var cardView: UIView! {
        didSet {
            cardView.backgroundColor = DesignSystem.Color.surface
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.06
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 4
        }
    }

    @IBOutlet private var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = DesignSystem.Font.cellDate
            dateTimeLabel.textColor = DesignSystem.Color.textSecondary
        }
    }

    @IBOutlet private var categoryBadge: CategoryBadgeView!

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = DesignSystem.Font.cellTitle
            titleLabel.textColor = DesignSystem.Color.textPrimary
        }
    }

    @IBOutlet private var notesLabel: UILabel! {
        didSet {
            notesLabel.font = DesignSystem.Font.cellNote
            notesLabel.textColor = DesignSystem.Color.textSecondary
            notesLabel.numberOfLines = 1
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }

    func configure(with activity: Activity) {
        dateTimeLabel.text = formatDateTime(date: activity.date, time: activity.time)
        titleLabel.text = activity.title
        notesLabel.text = activity.notes
        notesLabel.isHidden = activity.notes == nil || activity.notes?.isEmpty == true
        categoryBadge.configure(with: activity.category)
        categoryBadge.isHidden = activity.category == .other
    }

    private func formatDateTime(date: String, time: String) -> String {
        guard let d = DateFormatter.ISO8601DateHHmm.date(from: "\(date) \(time)") else {
            return "\(date) \(time)"
        }
        return DateFormatter.japYearMonthDayTime.string(from: d)
    }
}
