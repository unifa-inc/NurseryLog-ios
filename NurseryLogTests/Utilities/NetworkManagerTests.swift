import RxBlocking
import XCTest
@testable import NurseryLog

class NetworkManagerTests: XCTestCase {

    func test_shared_isMockNetworkManager_inTests() {
        XCTAssertTrue(NetworkManager.shared is MockNetworkManager)
    }

    func test_request_emitsRegisteredResult() throws {
        guard let mock = NetworkManager.shared as? MockNetworkManager else {
            XCTFail("Expected MockNetworkManager")
            return
        }
        let stub = [Activity.stub()]
        let params = ActivitiesListParameters(date: "2024-06-10")
        mock.registerResult(stub, forApiCall: .activitiesList(params))
        defer { mock.unregisterResponse(forApiCall: .activitiesList(params)) }

        let result: [Activity] = try NetworkManager.shared
            .request(endpoint: .activitiesList(params))
            .toBlocking()
            .first() ?? []

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, stub.first?.id)
    }

    func test_request_emitsRegisteredError() {
        guard let mock = NetworkManager.shared as? MockNetworkManager else {
            XCTFail("Expected MockNetworkManager")
            return
        }
        let params = ActivitiesListParameters(date: "2024-06-10")
        mock.registerError(NSError(domain: "test", code: 500), forApiCall: .activitiesList(params))
        defer { mock.unregisterResponse(forApiCall: .activitiesList(params)) }

        XCTAssertThrowsError(
            try NetworkManager.shared
                .request(endpoint: .activitiesList(params))
                .toBlocking()
                .first() as [Activity]?
        )
    }
}
