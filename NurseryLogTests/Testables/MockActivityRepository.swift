import RxSwift
@testable import NurseryLog

final class MockActivityRepository: ActivityRepository {
    var stubActivities: [Activity]
    var stubError: Error?
    var savedActivities: [Activity] = []

    init(stubActivities: [Activity] = [], stubError: Error? = nil) {
        self.stubActivities = stubActivities
        self.stubError = stubError
    }

    func fetchActivities(for date: String) -> Observable<[Activity]> {
        if let error = stubError { return .error(error) }
        return .just(stubActivities)
    }

    func save(activity: Activity) -> Observable<Void> {
        if let error = stubError { return .error(error) }
        savedActivities.append(activity)
        return .just(())
    }
}
