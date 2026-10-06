import RxCocoa
import RxSwift
import UIKit

protocol WithEmptyStateView: UIViewController {
    var emptyStateView: EmptyStateView { get }
    var emptyStateTarget: UIView { get }
}

extension WithEmptyStateView {
    func setupEmptyStateUI(message: String) {
        emptyStateView.setMessage(text: message)
    }
}

extension Reactive where Base: WithEmptyStateView {
    var isEmpty: Binder<Bool> {
        Binder(base) { base, empty in
            if empty {
                base.emptyStateView.add(to: base.emptyStateTarget)
                UIView.animate(withDuration: 0.2) { [weak base] in
                    base?.emptyStateView.alpha = 1
                }
            } else if base.emptyStateView.superview != nil {
                UIView.animate(withDuration: 0.2, animations: { [weak base] in
                    base?.emptyStateView.alpha = 0
                }, completion: { [weak base] _ in
                    base?.emptyStateView.removeFromSuperview()
                })
            }
        }
    }
}
