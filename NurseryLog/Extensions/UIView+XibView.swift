import UIKit

protocol XibView: UIView {
    var contentView: UIView! { get }

    init(frame: CGRect)
    init?(coder: NSCoder)
    func commonInit()
}

extension XibView {
    func commonInit() {
        let name = String(describing: type(of: self))
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
