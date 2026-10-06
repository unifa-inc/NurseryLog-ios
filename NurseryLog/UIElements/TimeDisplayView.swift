import RxCocoa
import RxSwift
import UIKit

final class TimeDisplayView: UIView {
    var onTap: (() -> Void)?

    private let label: UILabel = {
        let l = UILabel()
        l.font = DesignSystem.Font.timeDisplay
        l.textColor = DesignSystem.Color.textPrimary
        l.textAlignment = .center
        l.text = "11:00"
        return l
    }()

    private let selectedTimeRelay = BehaviorRelay<Date>(value: {
        let cal = Calendar.current
        return cal.date(bySettingHour: 11, minute: 0, second: 0, of: Date()) ?? Date()
    }())

    var selectedTime: Driver<Date> { selectedTimeRelay.asDriver() }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = DesignSystem.Color.timeBoxBorder.cgColor
        layer.cornerRadius = DesignSystem.Layout.cornerRadiusInput
        backgroundColor = DesignSystem.Color.surface

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = DesignSystem.Color.timeBoxBorder.cgColor
        layer.cornerRadius = DesignSystem.Layout.cornerRadiusInput
        backgroundColor = DesignSystem.Color.surface
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tap)
    }

    func setDate(_ date: Date) {
        selectedTimeRelay.accept(date)
        label.text = DateFormatter.clock.string(from: date)
    }

    @objc private func tapped() {
        onTap?()
        tapSubject.onNext(())
    }

    fileprivate let tapSubject = PublishSubject<Void>()
}

extension Reactive where Base: TimeDisplayView {
    var tap: Observable<Void> { base.tapSubject.asObservable() }
}
