import Alamofire
import Foundation

enum APIRouter: URLRequestConvertible {
    case activitiesList(_ parameters: ActivitiesListParameters)
    case activityCreate(_ parameters: ActivityCreateParameters)

    var method: HTTPMethod {
        switch self {
        case .activitiesList: return .get
        case .activityCreate: return .post
        }
    }

    var path: String {
        switch self {
        case .activitiesList: return "/activities"
        case .activityCreate: return "/activities"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try "https://api.nurserylog.local".asURL()
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.method = method
        switch self {
        case let .activitiesList(parameters):
            request = try URLEncodedFormParameterEncoder.default.encode(parameters, into: request)
        case let .activityCreate(parameters):
            request = try JSONParameterEncoder.default.encode(parameters, into: request)
        }
        return request
    }
}

extension APIRouter {
    var hashValue: Int? {
        var hasher = Hasher()
        switch self {
        case let .activitiesList(parameters):
            hasher.combine("activitiesList")
            hasher.combine(parameters.date)
        case let .activityCreate(parameters):
            hasher.combine("activityCreate")
            hasher.combine(parameters.id)
        }
        return hasher.finalize()
    }
}
