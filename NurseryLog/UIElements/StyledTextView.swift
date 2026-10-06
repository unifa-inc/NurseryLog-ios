import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import UIKit

extension MDCOutlinedTextArea {
    static func styled(label: String, placeholder: String) -> MDCOutlinedTextArea {
        let ta = MDCOutlinedTextArea()
        ta.setupThemed(text: label, placeholder: placeholder)
        ta.minimumNumberOfVisibleRows = 4
        return ta
    }
}
