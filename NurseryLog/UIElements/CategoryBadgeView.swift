import UIKit

final class CategoryBadgeView: UIView {
    private let label: UILabel = {
        let l = UILabel()
        l.font = DesignSystem.Font.tagLabel
        l.textColor = DesignSystem.Color.textSecondary
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = DesignSystem.Color.tagBorder.cgColor
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        ])
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    func configure(with category: Activity.Category) {
        label.text = category.displayName
    }
}
