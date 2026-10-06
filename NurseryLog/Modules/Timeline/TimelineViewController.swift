import NSObject_Rx
import RswiftResources
import RxCocoa
import RxRelay
import RxSwift
import UIKit

class TimelineViewController: ViewController, WithEmptyStateView {

    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "ActivityCell", bundle: nil), forCellReuseIdentifier: ActivityCell.reuseIdentifier)
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 90
            tableView.separatorStyle = .none
            tableView.backgroundColor = .clear
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 88, right: 0)
        }
    }
    @IBOutlet private var addActivityButton: AddActivityButton!
    @IBOutlet private var selectDateButton: SelectDateButton!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    let emptyStateView: EmptyStateView = .make()
    var emptyStateTarget: UIView { view }

    private let selectedDateRelay = BehaviorRelay<Date>(value: Date())

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "タイムライン"
        setupEmptyStateUI(message: "アクティビティーが登録されていません")
        selectDateButton.setTitle(DateFormatter.japYearMonthDayWeekday.string(from: selectedDateRelay.value))
    }

    override func bindData() {
        guard let viewModel = viewModel as? TimelineViewModel else {
            assertionFailure("Wrong ViewModel type")
            return
        }

        tableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)

        selectDateButton.rx.tap
            .map { [weak self] in { (picker: DatePickerViewController) in
                picker.initialDate = self?.selectedDateRelay.value ?? Date()
                picker.onConfirm = { date in
                    self?.selectedDateRelay.accept(date)
                    self?.selectDateButton.setTitle(DateFormatter.japYearMonthDayWeekday.string(from: date))
                }
            }}
            .bind(to: rx.presentDatePicker)
            .disposed(by: rx.disposeBag)

        let input = TimelineViewModel.Input(
            selectedDate: selectedDateRelay.asDriver(),
            reload: .just(())
        )

        guard let output = try? viewModel.transform(input) else { return }

        output.activities
            .drive(tableView.rx.items(
                cellIdentifier: ActivityCell.reuseIdentifier,
                cellType: ActivityCell.self
            )) { _, activity, cell in
                cell.configure(with: activity)
            }
            .disposed(by: rx.disposeBag)

        output.isEmpty
            .drive(rx.isEmpty)
            .disposed(by: rx.disposeBag)

        output.isEmpty
            .drive(tableView.rx.isHidden)
            .disposed(by: rx.disposeBag)

        output.isBusy
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: rx.disposeBag)

        output.errorMessage
            .filter { !$0.isEmpty }
            .drive(rx.showError)
            .disposed(by: rx.disposeBag)

        addActivityButton.rx.tap
            .bind(to: rx.pushAddActivity)
            .disposed(by: rx.disposeBag)

        tableView.rx.modelSelected(Activity.self)
            .asDriver()
            .drive(rx.pushDetail)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension TimelineViewController: UITableViewDelegate {}

// MARK: - Reactive

private extension Reactive where Base: TimelineViewController {
    var pushAddActivity: Binder<Void> {
        Binder(base) { base, _ in
            let today = DateFormatter.ISO8601Date.string(from: Date())
            base.pushViewController(from: R.storyboard.addActivityViewController, with: AddActivityViewModel(date: today))
        }
    }

    var pushDetail: Binder<Activity> {
        Binder(base) { base, activity in
            base.pushViewController(from: R.storyboard.activityDetailViewController, with: ActivityDetailViewModel(activity: activity))
        }
    }
}
