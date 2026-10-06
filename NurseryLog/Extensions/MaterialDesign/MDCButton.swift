import MaterialComponents.MaterialButtons_Theming
import UIKit

extension MDCButton {
    var defaultCornerRadius: CGFloat { frame.size.height / 2 }

    func doCommonContainedButtonSetup(scheme: MDCContainerScheme = .defaultScheme) {
        applyContainedTheme(withScheme: scheme)
        setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .normal)
        setTitleColor(UIColor.black.withAlphaComponent(0.7), for: .highlighted)
        setBackgroundColor(UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1), for: .disabled)
        setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .disabled)
        setElevation(.none, for: .normal)
        setElevation(.none, for: .highlighted)
        setElevation(.none, for: .disabled)
    }

    func doCommonBigButtonSetup(with title: String) {
        layer.cornerRadius = defaultCornerRadius
        setTitle(title, for: .normal)
    }
}
