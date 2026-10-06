import RxCocoa
import RxSwift
import UIKit

final class CategoryTagsView: UIView {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.distribution = .fillProportionally
        return sv
    }()

    private var buttons: [UIButton] = []
    private let selectedCategoryRelay = BehaviorRelay<Activity.Category>(value: .other)
    private var selectedCategory: Activity.Category? = nil

    var selectedCategoryDriver: Driver<Activity.Category> {
        selectedCategoryRelay.asDriver()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        setupButtons()
        applyDeselectedStyle(to: buttons)
    }

    private func setupButtons() {
        Activity.Category.allCases.forEach { category in
            let btn = UIButton(type: .custom)
            btn.setTitle(category.displayName, for: .normal)
            btn.titleLabel?.font = DesignSystem.Font.tagLabel
            btn.layer.cornerRadius = DesignSystem.Layout.cornerRadiusTag
            btn.layer.borderWidth = 1
            btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12)
            btn.tag = Activity.Category.allCases.firstIndex(of: category) ?? 0
            btn.addTarget(self, action: #selector(tagTapped(_:)), for: .touchUpInside)
            buttons.append(btn)
            stackView.addArrangedSubview(btn)
        }
    }

    @objc private func tagTapped(_ sender: UIButton) {
        let category = Activity.Category.allCases[sender.tag]
        if selectedCategory == category {
            selectedCategory = nil
            applyDeselectedStyle(to: buttons)
        } else {
            selectedCategory = category
            select(category)
            selectedCategoryRelay.accept(category)
        }
    }

    private func select(_ category: Activity.Category) {
        Activity.Category.allCases.enumerated().forEach { idx, cat in
            let btn = buttons[idx]
            let isSelected = cat == category
            btn.backgroundColor = isSelected ? DesignSystem.Color.tagSelectedBackground : DesignSystem.Color.surface
            btn.setTitleColor(isSelected ? DesignSystem.Color.tagSelectedText : DesignSystem.Color.tagText, for: .normal)
            btn.layer.borderColor = isSelected
                ? DesignSystem.Color.tagSelectedBackground.cgColor
                : DesignSystem.Color.tagBorder.cgColor
        }
    }

    private func applyDeselectedStyle(to buttons: [UIButton]) {
        buttons.forEach { btn in
            btn.backgroundColor = DesignSystem.Color.surface
            btn.setTitleColor(DesignSystem.Color.tagText, for: .normal)
            btn.layer.borderColor = DesignSystem.Color.tagBorder.cgColor
        }
    }
}
