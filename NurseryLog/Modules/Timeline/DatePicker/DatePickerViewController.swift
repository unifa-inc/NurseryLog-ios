import UIKit

class DatePickerViewController: UIViewController {
    var initialDate: Date = Date()
    var onConfirm: ((Date) -> Void)?

    private let cardView = UIView()
    private let datePicker = UIDatePicker()
    private let cancelButton = UIButton(type: .system)
    private let okButton = UIButton(type: .system)
    private let divider = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupCard()
        setupDatePicker()
        setupButtons()
        setupLayout()

        let tap = UITapGestureRecognizer(target: self, action: #selector(backdropTapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cardView.transform = CGAffineTransform(translationX: 0, y: cardView.bounds.height + 400)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.cardView.transform = .identity
        }
    }

    private func setupCard() {
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: -4)
        cardView.layer.shadowRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.date = initialDate
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(datePicker)
    }

    private func setupButtons() {
        divider.backgroundColor = UIColor(red: 0.82, green: 0.84, blue: 0.87, alpha: 1)
        divider.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(divider)

        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(DesignSystem.Color.primary, for: .normal)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cardView.addSubview(cancelButton)

        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        okButton.setTitleColor(DesignSystem.Color.primary, for: .normal)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        cardView.addSubview(okButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            datePicker.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            divider.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 8),
            divider.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),

            cancelButton.topAnchor.constraint(equalTo: divider.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 52),

            okButton.topAnchor.constraint(equalTo: divider.bottomAnchor),
            okButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            okButton.heightAnchor.constraint(equalToConstant: 52),
            okButton.widthAnchor.constraint(equalTo: cancelButton.widthAnchor),
            okButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),

            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    @objc private func cancelTapped() { dismissSheet() }

    @objc private func okTapped() {
        onConfirm?(datePicker.date)
        dismissSheet()
    }

    @objc private func backdropTapped() { dismissSheet() }

    private func dismissSheet() {
        UIView.animate(withDuration: 0.25) {
            self.view.backgroundColor = .clear
            self.cardView.transform = CGAffineTransform(translationX: 0, y: self.cardView.bounds.height + 400)
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
}

extension DatePickerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        touch.view == view
    }
}
