import UIKit

final class EmptyStateView: UIView {
    @IBOutlet private var iconImageView: UIImageView!
    @IBOutlet private var messageLabel: UILabel!

    func setMessage(text: String) {
        messageLabel.text = text
        messageLabel.font = DesignSystem.Font.emptyStateText
        messageLabel.textColor = DesignSystem.Color.textSecondary
    }

    func add(to view: UIView) {
        alpha = 0
        translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(self, at: 0)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    static func make() -> EmptyStateView {
        UINib(nibName: "EmptyStateView", bundle: nil).instantiate(withOwner: nil).first as! EmptyStateView
    }
}
