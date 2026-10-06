import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
    var isBusy: Binder<Bool> {
        Binder(base) { base, busy in
            if busy {
                base.showActivityIndicator()
            } else {
                base.hideActivityIndicator()
            }
        }
    }

    var dismiss: Binder<Void> {
        Binder(base) { base, _ in
            base.dismiss(animated: true)
        }
    }

    var popViewController: Binder<Void> {
        Binder(base) { base, _ in
            base.navigationController?.popViewController(animated: true)
        }
    }

    var showError: Binder<String> {
        Binder(base) { base, message in
            base.showAlert(message: message)
        }
    }

    var presentTimePicker: Binder<(TimePickerViewController) -> Void> {
        Binder(base) { base, configure in
            let picker = TimePickerViewController()
            configure(picker)
            picker.modalPresentationStyle = .overFullScreen
            picker.modalTransitionStyle = .crossDissolve
            base.present(picker, animated: false)
        }
    }

    var presentDatePicker: Binder<(DatePickerViewController) -> Void> {
        Binder(base) { base, configure in
            let picker = DatePickerViewController()
            configure(picker)
            picker.modalPresentationStyle = .overFullScreen
            picker.modalTransitionStyle = .crossDissolve
            base.present(picker, animated: false)
        }
    }

    var keyboardBottomInset: Binder<CGFloat> {
        Binder(base) { base, height in
            base.additionalSafeAreaInsets.bottom = max(0, height - base.view.safeAreaInsets.bottom)
        }
    }

    var viewWillAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).mapToVoid()
        return ControlEvent(events: source)
    }

    var viewDidAppear: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).mapToVoid()
        return ControlEvent(events: source)
    }
}

private var activityIndicatorKey: UInt8 = 0

private extension UIViewController {
    func showActivityIndicator() {
        guard objc_getAssociatedObject(self, &activityIndicatorKey) == nil else { return }
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = DesignSystem.Color.primary
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        indicator.startAnimating()
        objc_setAssociatedObject(self, &activityIndicatorKey, indicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    func hideActivityIndicator() {
        guard let indicator = objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView else { return }
        indicator.removeFromSuperview()
        objc_setAssociatedObject(self, &activityIndicatorKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UIViewController {
    func removeBackButtonTitle() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func setTapGestureToEndEditing() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}
