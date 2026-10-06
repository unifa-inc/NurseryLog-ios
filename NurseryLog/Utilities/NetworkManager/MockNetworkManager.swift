import Foundation
import RxSwift

struct RegisteredResponse {
    var result: Decodable?
    var error: Error?
    var responseDelay: RxTimeInterval?
}

class MockNetworkManager: NetworkManager {
    private var registeredResponses: [Int: RegisteredResponse] = [:]

    override func request<Result: Decodable>(
        endpoint: APIRouter,
        scheduler: SchedulerType = MainScheduler.instance
    ) -> Observable<Result> {
        guard let hash = endpoint.hashValue else {
            return .error(InternalError(errorDescription: "hashValue not added for this endpoint"))
        }
        if let error = registeredResponses[hash]?.error {
            if let delay = registeredResponses[hash]?.responseDelay {
                return .error(error).delay(delay, scheduler: MainScheduler.instance)
            }
            return .error(error)
        }
        if let result = registeredResponses[hash]?.result as? Result {
            if let delay = registeredResponses[hash]?.responseDelay {
                return .just(result).delay(delay, scheduler: MainScheduler.instance)
            }
            return .just(result)
        }
        return .error(InternalError(errorDescription: "No response registered for this endpoint"))
    }

    override func noResultRequest(
        endpoint: APIRouter,
        scheduler: SchedulerType = MainScheduler.instance
    ) -> Observable<Void> {
        guard let hash = endpoint.hashValue else {
            return .error(InternalError(errorDescription: "hashValue not added for this endpoint"))
        }
        if let error = registeredResponses[hash]?.error {
            return .error(error)
        }
        return .just(())
    }

    func registerResult(_ result: some Decodable, forApiCall call: APIRouter,
                        responseDelay: RxTimeInterval? = nil) {
        guard let hash = call.hashValue else { return }
        registeredResponses[hash] = RegisteredResponse(result: result, error: nil,
                                                       responseDelay: responseDelay)
    }

    func registerError(_ error: Error, forApiCall call: APIRouter,
                       responseDelay: RxTimeInterval? = nil) {
        guard let hash = call.hashValue else { return }
        registeredResponses[hash] = RegisteredResponse(result: nil, error: error,
                                                       responseDelay: responseDelay)
    }

    func unregisterResponse(forApiCall call: APIRouter) {
        guard let hash = call.hashValue else { return }
        registeredResponses.removeValue(forKey: hash)
    }
}
