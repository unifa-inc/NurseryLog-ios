import MaterialComponents.MaterialTextControls_FilledTextAreasTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import RxCocoa
import RxSwift
import UIKit

private extension MDCBaseTextArea {
    func setup(text: String, placeholder: String,
               leadingHelper: String? = nil, trailingHelper: String? = nil) {
        label.text = text
        self.placeholder = placeholder
        leadingAssistiveLabel.text = leadingHelper
        trailingAssistiveLabel.text = trailingHelper
        sizeToFit()
    }
}

extension Reactive where Base: MDCBaseTextArea {
    var text: ControlProperty<String?> { base.textView.rx.text }
}

protocol ThemableTextArea: MDCBaseTextArea {
    func applyTheme(withScheme scheme: MDCContainerScheming)
    func applyErrorTheme(withScheme scheme: MDCContainerScheming)
    func applyModifiedTheme(withScheme scheme: MDCContainerScheme)
    func setupThemed(withScheme scheme: MDCContainerScheme, text: String, placeholder: String,
                     leadingHelper: String?, trailingHelper: String?)
    func setBackgroundColor(_ backgroundColor: UIColor, for state: MDCTextControlState)
    func setInputFont(_ font: UIFont)
}

extension MDCOutlinedTextArea: ThemableTextArea {
    func setBackgroundColor(_: UIColor, for _: MDCTextControlState) {}
}

extension ThemableTextArea {
    func setupThemed(withScheme scheme: MDCContainerScheme = .defaultScheme,
                     text: String, placeholder: String,
                     leadingHelper: String? = nil, trailingHelper: String? = nil) {
        setup(text: text, placeholder: placeholder,
              leadingHelper: leadingHelper, trailingHelper: trailingHelper)
        applyModifiedTheme(withScheme: scheme)
    }

    func setupInputLimit(_ limit: Int) {
        trailingAssistiveLabel.text = "0/\(limit)"
        let tv = textView
        let counterLabel = trailingAssistiveLabel
        NotificationCenter.default.addObserver(
            forName: UITextView.textDidChangeNotification,
            object: tv,
            queue: .main
        ) { _ in
            counterLabel.text = "\(tv.text.count)/\(limit)"
        }
    }

    func applyModifiedTheme(withScheme scheme: MDCContainerScheme) {
        applyTheme(withScheme: scheme)
        setBackgroundColor(scheme.colorScheme.surfaceColor, for: .normal)
        setBackgroundColor(scheme.colorScheme.surfaceColor, for: .editing)
        setInputFont(scheme.typographyScheme.body1)
    }

    func applyModifiedErrorTheme(withScheme scheme: MDCContainerScheme) {
        applyErrorTheme(withScheme: scheme)
        setBackgroundColor(scheme.colorScheme.surfaceColor, for: .normal)
        setBackgroundColor(scheme.colorScheme.surfaceColor, for: .editing)
        setInputFont(scheme.typographyScheme.body1)
    }

    func setInputFont(_ font: UIFont) { textView.font = font }
}

extension Reactive where Base: MDCBaseTextArea {
    var leadingHelperText: Binder<String> {
        Binder(base) { base, text in base.leadingAssistiveLabel.text = text }
    }
    var trailingHelperText: Binder<String> {
        Binder(base) { base, text in base.trailingAssistiveLabel.text = text }
    }
}

extension Reactive where Base: ThemableTextArea {
    var isErrorTheme: Binder<Bool> {
        Binder(base) { base, isError in
            if isError { base.applyModifiedErrorTheme(withScheme: MDCContainerScheme.defaultScheme) }
            else { base.applyModifiedTheme(withScheme: MDCContainerScheme.defaultScheme) }
        }
    }
}
