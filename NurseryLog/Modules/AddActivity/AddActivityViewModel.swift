import RxCocoa
import RxRelay
import RxSwift

class AddActivityViewModel: ViewModel, ViewModelProtocol {
    private static let timeFormatter: DateFormatter = .clock
    private static let timestampFormatter: DateFormatter = .ISO8601DateTime
    
    struct Input {
        let title: Driver<String>
        let notes: Driver<String>
        let selectedCategory: Driver<Activity.Category>
        let selectedTime: Driver<Date>
        let saveButtonTap: Driver<Void>
    }

    struct Output {
        let saveEnabled: Driver<Bool>
        let saved: Driver<Void>
        let isBusy: Driver<Bool>
        let errorMessage: Driver<String>
    }

    private let date: String
    private let repository: ActivityRepository

    init(date: String, repository: ActivityRepository = LocalActivityRepository()) {
        self.date = date
        self.repository = repository
    }

    func transform(_ input: Input) throws -> Output {
        let saveEnabled = input.title
            .map { _ in true }

        let combinedInfo = Driver.combineLatest(
            input.title,
            input.notes,
            input.selectedCategory,
            input.selectedTime
        )
        
        let saved = input.saveButtonTap
            .withLatestFrom(combinedInfo)
            .flatMapLatest { [weak self] title, notes, category, time -> Driver<Void> in
                guard let self else { return .empty() }
                let activity = Activity(
                    id: UUID().uuidString,
                    date: self.date,
                    time: Self.timeFormatter.string(from: time),
                    category: category,
                    title: title,
                    notes: notes.isEmpty ? nil : notes,
                    createdAt: Self.timestampFormatter.string(from: Date())
                )
                return self.repository
                    .save(activity: activity)
                    .trackActivity(self.activityIndicator)
                    .catch { [weak self] error in
                        self?.errorSinkRelay.accept(error.localizedDescription)
                        return .empty()
                    }
                    .asDriver(onErrorJustReturn: ())
            }

        return Output(
            saveEnabled: saveEnabled,
            saved: saved,
            isBusy: activityIndicator.asDriver(),
            errorMessage: errorSinkRelay.asDriver(onErrorJustReturn: "")
        )
    }
}
