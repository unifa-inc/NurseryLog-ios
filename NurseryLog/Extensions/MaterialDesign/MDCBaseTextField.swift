import MaterialComponents.MaterialTextControls_FilledTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming
import RxCocoa
import RxSwift
import UIKit

private extension MDCBaseTextField {
    func setup(text: String? = nil, placeholder: String? = nil,
               leadingHelper: String? = nil, trailingHelper: String? = nil) {
        label.text = text
        self.placeholder = placeholder
        leadingAssistiveLabel.text = leadingHelper
        trailingAssistiveLabel.text = trailingHelper
        sizeToFit()
    }
}

protocol ThemableTextField: MDCBaseTextField {
    func applyTheme(withScheme scheme: MDCContainerScheming)
    func applyErrorTheme(withScheme scheme: MDCContainerScheming)
    func applyModifiedTheme(withScheme scheme: MDCContainerScheme)
    func setupThemed(withScheme scheme: MDCContainerScheme, text: String?, placeholder: String?,
                     leadingHelper: String?, trailingHelper: String?)
    func setBackgroundColor(_ backgroundColor: UIColor, for state: MDCTextControlState)
    func setInputFont(_ font: UIFont)
}

extension MDCOutlinedTextField: ThemableTextField {
    func setBackgroundColor(_: UIColor, for _: MDCTextControlState) {}
}

extension ThemableTextField {
    func setupThemed(withScheme scheme: MDCContainerScheme = .defaultScheme,
                     text: String? = nil, placeholder: String? = nil,
                     leadingHelper: String? = nil, trailingHelper: String? = nil) {
        setup(text: text, placeholder: placeholder,
              leadingHelper: leadingHelper, trailingHelper: trailingHelper)
        applyModifiedTheme(withScheme: scheme)
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

    func setInputFont(_ font: UIFont) { self.font = font }
}

extension Reactive where Base: MDCBaseTextField {
    var leadingHelperText: Binder<String> {
        Binder(base) { base, text in base.leadingAssistiveLabel.text = text }
    }
    var trailingHelperText: Binder<String> {
        Binder(base) { base, text in base.trailingAssistiveLabel.text = text }
    }
}

extension Reactive where Base: ThemableTextField {
    var isErrorTheme: Binder<Bool> {
        Binder(base) { base, isError in
            if isError { base.applyModifiedErrorTheme(withScheme: MDCContainerScheme.defaultScheme) }
            else { base.applyModifiedTheme(withScheme: MDCContainerScheme.defaultScheme) }
        }
    }
}
