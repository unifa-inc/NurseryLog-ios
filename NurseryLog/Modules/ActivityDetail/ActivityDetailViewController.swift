import NSObject_Rx
import RxCocoa
import RxSwift
import UIKit

class ActivityDetailViewController: ViewController {
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var activityDetailView: ActivityDetailView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "アクティビティー"
    }

    override func bindData() {
        guard let viewModel = viewModel as? ActivityDetailViewModel else {
            assertionFailure("Wrong ViewModel type")
            return
        }

        guard let output = try? viewModel.transform(ActivityDetailViewModel.Input()) else { return }

        output.dateTime
            .drive(activityDetailView.rx.dateTime)
            .disposed(by: activityDetailView.rx.disposeBag)

        output.category
            .drive(activityDetailView.rx.category)
            .disposed(by: activityDetailView.rx.disposeBag)

        output.title
            .drive(activityDetailView.rx.title)
            .disposed(by: activityDetailView.rx.disposeBag)

        output.notes
            .drive(activityDetailView.rx.notes)
            .disposed(by: activityDetailView.rx.disposeBag)
    }
}
