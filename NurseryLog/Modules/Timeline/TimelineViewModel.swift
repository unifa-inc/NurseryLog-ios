import RxCocoa
import RxRelay
import RxSwift

class TimelineViewModel: ViewModel, ViewModelProtocol {
    private static let dateFormatter: DateFormatter = .ISO8601Date

    struct Input {
        let selectedDate: Driver<Date>
        let reload: Driver<Void>
    }

    struct Output {
        let activities: Driver<[Activity]>
        let isEmpty: Driver<Bool>
        let isBusy: Driver<Bool>
        let errorMessage: Driver<String>
    }

    private let repository: ActivityRepository

    init(repository: ActivityRepository = LocalActivityRepository()) {
        self.repository = repository
    }

    func transform(_ input: Input) throws -> Output {
        let date = input.selectedDate
            .map { Self.dateFormatter.string(from: $0) }

        let isLoading = BehaviorRelay<Bool>(value: false)

        let fetch = Observable.combineLatest(
            input.reload.asObservable(),
            date.asObservable()
        )
        .flatMapLatest { [weak self] _, dateString -> Observable<[Activity]> in
            guard let self else { return .empty() }
            isLoading.accept(true)
            return self.repository
                .fetchActivities(for: dateString)
                .catch { [weak self] error in
                    self?.errorSinkRelay.accept(error.localizedDescription)
                    return .just([])
                }
                .do(onNext: { _ in isLoading.accept(false) },
                    onError: { _ in isLoading.accept(false) })
        }
        .asDriver(onErrorJustReturn: [])

        let isEmpty = Driver.combineLatest(fetch, isLoading.asDriver())
            .map { activities, loading in loading && activities.isEmpty }

        return Output(
            activities: fetch,
            isEmpty: isEmpty,
            isBusy: isLoading.asDriver(),
            errorMessage: errorSinkRelay.asDriver(onErrorJustReturn: "")
        )
    }

}
