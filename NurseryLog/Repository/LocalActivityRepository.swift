import Foundation
import RxSwift

final class LocalActivityRepository: ActivityRepository {

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    func fetchActivities(for date: String) -> Observable<[Activity]> {
        seedIfNeeded()
        let cached = RMActivity.getAll(for: date).compactMap { $0.toDomain() }
        if !cached.isEmpty {
            return .just(cached)
        }
        #if DEBUG
        return .just([])
        #else
        let parameters = ActivitiesListParameters(date: date)
        return networkManager
            .request(endpoint: .activitiesList(parameters))
            .map { (response: [ActivityResponse]) in response.compactMap { $0.toDomain() } }
        #endif
    }

    func save(activity: Activity) -> Observable<Void> {
        Observable.create { observer in
            do {
                try RMActivity.insert(activity)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }

    private let networkManager: NetworkManager

    private func seedIfNeeded() {
        #if !DEBUG
        let key = "NurseryLog.didSeedActivities.v4"
        guard !UserDefaults.standard.bool(forKey: key) else { return }
        #endif
        guard let url = Bundle.main.url(forResource: "SampleActivities", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else { return }
        guard let activities = try? JSONDecoder.iso8601.decode([Activity].self, from: data)
        else { return }
        activities.forEach { try? RMActivity.insert($0) }
        #if !DEBUG
        UserDefaults.standard.set(true, forKey: key)
        #endif
    }
}
