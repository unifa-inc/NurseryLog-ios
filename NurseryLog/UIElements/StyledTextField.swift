import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming
import UIKit

extension MDCOutlinedTextField {
    static func styled(label: String? = nil, placeholder: String? = nil) -> MDCOutlinedTextField {
        let tf = MDCOutlinedTextField()
        tf.setupThemed(text: label, placeholder: placeholder)
        return tf
    }
}
