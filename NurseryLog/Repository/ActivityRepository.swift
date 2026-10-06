import RxSwift

protocol ActivityRepository {
    func fetchActivities(for date: String) -> Observable<[Activity]>
    func save(activity: Activity) -> Observable<Void>
}
