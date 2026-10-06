import RxCocoa
import RxRelay
import RxSwift

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input) throws -> Output
}

class ViewModel: NSObject {
    let activityIndicator = ActivityIndicator()
    let errorSinkRelay = PublishRelay<String>()
}
