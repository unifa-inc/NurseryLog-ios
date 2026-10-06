import RxCocoa
import RxSwift

class ActivityDetailViewModel: ViewModel, ViewModelProtocol {

    struct Input {}

    struct Output {
        let dateTime: Driver<String>
        let category: Driver<Activity.Category>
        let title: Driver<String>
        let notes: Driver<String?>
    }

    private let activity: Activity

    init(activity: Activity) {
        self.activity = activity
    }

    func transform(_ input: Input) throws -> Output {
        Output(
            dateTime: .just(formatDateTime()),
            category: .just(activity.category),
            title: .just(activity.title),
            notes: .just(activity.notes)
        )
    }

    private func formatDateTime() -> String {
        guard let date = DateFormatter.ISO8601DateHHmm.date(from: "\(activity.date) \(activity.time)") else {
            return "\(activity.date) \(activity.time)"
        }
        return DateFormatter.with(format: "dd/MM/yyyy h:mm a").string(from: date)
    }
}
