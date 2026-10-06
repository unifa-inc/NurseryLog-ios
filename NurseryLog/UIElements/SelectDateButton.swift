import RxCocoa
import RxSwift
import UIKit

final class SelectDateButton: UIView {
    private let label: UILabel = {
        let l = UILabel()
        l.font = DesignSystem.Font.buttonTitle
        l.textColor = DesignSystem.Color.textPrimary
        l.textAlignment = .center
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

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    private func setup() {
        layer.borderWidth = 1
        layer.borderColor = DesignSystem.Color.inputBorder.cgColor
        backgroundColor = DesignSystem.Color.surface

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }

    func setTitle(_ text: String) {
        label.text = text
    }

    @objc private func tapped() {
        tapSubject.onNext(())
    }

    fileprivate let tapSubject = PublishSubject<Void>()
}

extension Reactive where Base: SelectDateButton {
    var tap: Observable<Void> { base.tapSubject.asObservable() }
}
