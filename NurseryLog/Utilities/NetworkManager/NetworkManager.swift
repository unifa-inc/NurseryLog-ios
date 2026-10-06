import Alamofire
import Foundation
import RxAlamofire
import RxSwift

class NetworkManager {
    #if DEBUG
    static let shared: NetworkManager = {
        if Application.isRunningUnitTests {
            return MockNetworkManager()
        } else {
            return NetworkManager()
        }
    }()
    #else
    static let shared = NetworkManager()
    #endif

    private let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return Session(configuration: config)
    }()

    func request<Result: Decodable>(
        endpoint: APIRouter,
        scheduler: SchedulerType = MainScheduler.instance
    ) -> Observable<Result> {
        session.rx
            .request(urlRequest: endpoint)
            .observe(on: scheduler)
            .responseData()
            .map { _, data in
                try JSONDecoder.iso8601.decode(Result.self, from: data)
            }
    }

    func noResultRequest(
        endpoint: APIRouter,
        scheduler: SchedulerType = MainScheduler.instance
    ) -> Observable<Void> {
        session.rx
            .request(urlRequest: endpoint)
            .observe(on: scheduler)
            .responseData()
            .map { _ in () }
    }
}
