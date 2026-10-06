import MaterialComponents.MaterialButtons_Theming
import UIKit

final class PrimaryButton: MDCButton {
    override var isEnabled: Bool {
        get { super.isEnabled }
        set {
            super.isEnabled = newValue
            guard let text = titleLabel?.text else { return }
            setup(with: text)
        }
    }

    func setup(with title: String, scheme: MDCContainerScheme = .defaultScheme) {
        doCommonContainedButtonSetup(scheme: scheme)
        doCommonBigButtonSetup(with: title)
        applyShadow()
    }

    private func applyShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
