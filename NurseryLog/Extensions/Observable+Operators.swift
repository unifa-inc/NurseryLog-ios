import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        map { _ in () }
    }
}
