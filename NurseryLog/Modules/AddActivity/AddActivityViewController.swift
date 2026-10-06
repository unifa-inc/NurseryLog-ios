import MaterialComponents.MaterialTextControls_OutlinedTextFieldsTheming
import MaterialComponents.MaterialTextControls_OutlinedTextAreasTheming
import NSObject_Rx
import RswiftResources
import RxCocoa
import RxSwift
import UIKit

class AddActivityViewController: ViewController {

    // MARK: - Outlets

    @IBOutlet private var subtitleLabel: UILabel!
    @IBOutlet private var timeRowStack: UIStackView!
    @IBOutlet private var timeSectionLabel: UILabel! {
        didSet {
            timeSectionLabel.font = DesignSystem.Font.cellTitle
            timeSectionLabel.textColor = DesignSystem.Color.textPrimary
        }
    }
    @IBOutlet private var timeBoxView: TimeDisplayView!
    @IBOutlet private var titleSectionLabel: UILabel! {
        didSet {
            titleSectionLabel.font = DesignSystem.Font.cellTitle
            titleSectionLabel.textColor = DesignSystem.Color.textPrimary
        }
    }
    @IBOutlet private var titleTextField: MDCOutlinedTextField! {
        didSet {
            titleTextField.setupThemed(text: "タイトル", placeholder: "タイトル")
        }
    }
    @IBOutlet private var categoryTagsView: CategoryTagsView!
    @IBOutlet private var notesSectionLabel: UILabel! {
        didSet {
            notesSectionLabel.font = DesignSystem.Font.cellTitle
            notesSectionLabel.textColor = DesignSystem.Color.textPrimary
        }
    }
    @IBOutlet private var notesTextArea: MDCOutlinedTextArea! {
        didSet {
            notesTextArea.setupThemed(text: "ノート", placeholder: "ノートを入力")
            notesTextArea.minimumNumberOfVisibleRows = 4
            notesTextArea.setupInputLimit(100)
        }
    }
    @IBOutlet private var saveButton: PrimaryButton! {
        didSet {
            saveButton.setup(with: "保存")
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "アクティビティー"
        view.backgroundColor = DesignSystem.Color.surface
        setTapGestureToEndEditing()
    }

    // MARK: - Bind

    override func bindData() {
        guard let viewModel = viewModel as? AddActivityViewModel else {
            assertionFailure("Wrong ViewModel type")
            return
        }

        let input = AddActivityViewModel.Input(
            title: titleTextField.rx.text.orEmpty.asDriver(),
            notes: notesTextArea.textView.rx.text.orEmpty.asDriver(),
            selectedCategory: categoryTagsView.selectedCategoryDriver,
            selectedTime: timeBoxView.selectedTime,
            saveButtonTap: saveButton.rx.tap.asDriver()
        )

        guard let output = try? viewModel.transform(input) else { return }

        output.saved
            .drive(rx.popViewController)
            .disposed(by: rx.disposeBag)

        output.isBusy
            .drive(rx.isBusy)
            .disposed(by: rx.disposeBag)

        output.errorMessage
            .filter { !$0.isEmpty }
            .drive(rx.showError)
            .disposed(by: rx.disposeBag)

        timeBoxView.rx.tap
            .map { [weak self] in { (picker: TimePickerViewController) in
                picker.onConfirm = { date in self?.timeBoxView.setDate(date) }
            }}
            .bind(to: rx.presentTimePicker)
            .disposed(by: rx.disposeBag)

        let keyboardShow = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }
            .asDriver(onErrorJustReturn: 0)

        let keyboardHide = NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
            .asDriver(onErrorJustReturn: 0)

        Driver.merge(keyboardShow, keyboardHide)
            .drive(rx.keyboardBottomInset)
            .disposed(by: rx.disposeBag)
    }
}
