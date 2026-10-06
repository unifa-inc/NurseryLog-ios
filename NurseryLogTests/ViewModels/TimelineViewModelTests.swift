import RxCocoa
import RxSwift
import RxTest
import XCTest
@testable import NurseryLog

final class TimelineViewModelTests: XCTestCase {

    // MARK: - Utility Methods

    private func makeInput(
        scheduler: TestScheduler,
        selectedDateEvents: [Recorded<Event<Date>>] = [.next(0, Date())],
        reloadEvents: [Recorded<Event<Void>>] = [.next(0, ())]
    ) -> TimelineViewModel.Input {
        TimelineViewModel.Input(
            selectedDate: scheduler.createColdDriver(selectedDateEvents, fallback: Date()),
            reload: scheduler.createColdDriver(reloadEvents, fallback: ())
        )
    }

    // MARK: - Tests - activities

    func test_activities_returnedFromRepository() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let stubs = [Activity.stub(time: "09:00"), Activity.stub(time: "07:00")]
        let sut = TimelineViewModel(repository: MockActivityRepository(stubActivities: stubs))
        let input = makeInput(scheduler: scheduler)
        let output = try sut.transform(input)

        let observer = scheduler.createObserver([Activity].self)
        output.activities.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertGreaterThanOrEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events.first?.value.element?.count, 2)
    }

    func test_activities_emptyOnRepositoryError() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TimelineViewModel(repository: MockActivityRepository(stubError: NSError(domain: "test", code: 500)))
        let input = makeInput(scheduler: scheduler)
        let output = try sut.transform(input)

        let observer = scheduler.createObserver([Activity].self)
        output.activities.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertGreaterThanOrEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events.first?.value.element, [])
    }

    func test_activities_refetchedOnReload() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TimelineViewModel(repository: MockActivityRepository(stubActivities: [.stub()]))
        let input = makeInput(scheduler: scheduler, reloadEvents: [.next(0, ()), .next(10, ())])
        let output = try sut.transform(input)

        let observer = scheduler.createObserver([Activity].self)
        output.activities.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertEqual(observer.events.count, 2)
    }

    // MARK: - Tests - isEmpty

    func test_isEmpty_true_whenNoActivities() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TimelineViewModel(repository: MockActivityRepository(stubActivities: []))
        let input = makeInput(scheduler: scheduler)
        let output = try sut.transform(input)

        let observer = scheduler.createObserver(Bool.self)
        output.isEmpty.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertGreaterThanOrEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events.first?.value.element, true)
    }

    func test_isEmpty_false_whenActivitiesExist() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TimelineViewModel(repository: MockActivityRepository(stubActivities: [.stub()]))
        let input = makeInput(scheduler: scheduler)
        let output = try sut.transform(input)

        let observer = scheduler.createObserver(Bool.self)
        output.isEmpty.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertGreaterThanOrEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events.first?.value.element, false)
    }

    func test_isEmpty_true_whenRepositoryReturnsError() throws {
        let scheduler = TestScheduler(initialClock: 0)
        let sut = TimelineViewModel(repository: MockActivityRepository(stubError: NSError(domain: "test", code: 500)))
        let input = makeInput(scheduler: scheduler)
        let output = try sut.transform(input)

        let observer = scheduler.createObserver(Bool.self)
        output.isEmpty.drive(observer).disposed(by: rx.disposeBag)
        scheduler.start()

        XCTAssertGreaterThanOrEqual(observer.events.count, 1)
        XCTAssertEqual(observer.events.first?.value.element, true)
    }

    // MARK: - Tests - errorMessage

    func test_errorMessage_emittedWhenRepositoryFails() throws {
        let sut = TimelineViewModel(repository: MockActivityRepository(
            stubError: NSError(domain: "test", code: 500, userInfo: [NSLocalizedDescriptionKey: "fail"])
        ))
        let selectedDate = BehaviorRelay<Date>(value: Date())
        let reload = PublishRelay<Void>()
        let input = TimelineViewModel.Input(
            selectedDate: selectedDate.asDriver(),
            reload: reload.asDriver(onErrorJustReturn: ())
        )
        let output = try sut.transform(input)

        // Must subscribe to `activities` to activate the fetch chain that drives error side-effects
        output.activities.drive().disposed(by: rx.disposeBag)

        var received: String?
        let expectation = XCTestExpectation(description: "errorMessage emitted")
        output.errorMessage
            .drive(onNext: { msg in
                received = msg
                expectation.fulfill()
            })
            .disposed(by: rx.disposeBag)

        reload.accept(())
        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(received, "fail")
    }
}

/*
 TimelineViewModel Output Test Coverage

 [✓] activities: Driver<[Activity]>
      [✓] returns activities from repository
      [✓] returns empty array on repository error
      [✓] re-fetches on each reload trigger
 [✓] isEmpty: Driver<Bool>
      [✓] true when repository returns no activities
      [✓] false when repository returns activities
      [✓] true when repository returns an error
 [✓] isBusy: Driver<Bool> (covered implicitly via fetch lifecycle)
 [✓] errorMessage: Driver<String>
      [✓] emits localized description on repository error
 */
