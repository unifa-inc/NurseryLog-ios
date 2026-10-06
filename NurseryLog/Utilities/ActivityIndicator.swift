import RxCocoa
import RxSwift

private final class ActivityToken: Disposable {
    private let decrement: () -> Void
    init(decrement: @escaping () -> Void) { self.decrement = decrement }
    func dispose() { decrement() }
}

final class ActivityIndicator: SharedSequenceConvertibleType {
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let relay = BehaviorRelay<Bool>(value: false)
    private var count = 0

    func asSharedSequence() -> Driver<Bool> {
        relay.asDriver()
    }

    func asDriver() -> Driver<Bool> {
        relay.asDriver()
    }

    fileprivate func increment() {
        lock.lock()
        count += 1
        relay.accept(true)
        lock.unlock()
    }

    fileprivate func decrement() {
        lock.lock()
        count -= 1
        if count == 0 { relay.accept(false) }
        lock.unlock()
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ indicator: ActivityIndicator) -> Observable<Element> {
        Observable.using({
            indicator.increment()
            return ActivityToken(decrement: indicator.decrement)
        }, observableFactory: { (_: ActivityToken) in
            self.asObservable()
        })
    }
}
