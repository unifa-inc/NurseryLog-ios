import RxCocoa
import RxSwift
import RxTest
@testable import NurseryLog

internal extension TestScheduler {
    func createColdDriver<Element>(_ events: [Recorded<Event<Element>>], fallback: Element) -> Driver<Element> {
        createColdObservable(events).asDriver(onErrorJustReturn: fallback)
    }
}
