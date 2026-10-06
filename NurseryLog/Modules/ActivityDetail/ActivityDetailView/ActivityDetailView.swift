import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

final class ActivityDetailView: UIView, XibView {
    // swiftlint:disable:next private_outlet
    @IBOutlet var contentView: UIView!

    @IBOutlet fileprivate var cardView: UIView! {
        didSet {
            cardView.backgroundColor = DesignSystem.Color.surface
            cardView.layer.masksToBounds = false
            cardView.layer.shadowColor = UIColor.black.cgColor
            cardView.layer.shadowOpacity = 0.08
            cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
            cardView.layer.shadowRadius = 6
        }
    }

    @IBOutlet fileprivate var dateTimeLabel: UILabel! {
        didSet {
            dateTimeLabel.font = DesignSystem.Font.cellDate
            dateTimeLabel.textColor = DesignSystem.Color.textSecondary
        }
    }

    @IBOutlet fileprivate var categoryBadge: CategoryBadgeView!

    @IBOutlet fileprivate var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            titleLabel.textColor = DesignSystem.Color.textPrimary
            titleLabel.numberOfLines = 0
        }
    }

    @IBOutlet fileprivate var separatorView: UIView! {
        didSet {
            separatorView.backgroundColor = DesignSystem.Color.tagBorder
        }
    }

    @IBOutlet fileprivate var notesLabel: UILabel! {
        didSet {
            notesLabel.font = DesignSystem.Font.label
            notesLabel.textColor = DesignSystem.Color.textSecondary
            notesLabel.numberOfLines = 0
        }
    }

    override required init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Reactive

extension Reactive where Base: ActivityDetailView {
    var dateTime: Binder<String> {
        Binder(base) { base, text in
            base.dateTimeLabel.text = text
        }
    }

    var category: Binder<Activity.Category> {
        Binder(base) { base, category in
            base.categoryBadge.configure(with: category)
            base.categoryBadge.isHidden = category == .other
        }
    }

    var title: Binder<String> {
        Binder(base) { base, text in
            base.titleLabel.text = text
        }
    }

    var notes: Binder<String?> {
        Binder(base) { base, text in
            let isEmpty = text == nil || text?.isEmpty == true
            base.notesLabel.text = text
            base.notesLabel.isHidden = isEmpty
            base.separatorView.isHidden = isEmpty
        }
    }
}
