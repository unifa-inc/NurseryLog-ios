import UIKit

extension UINavigationBar {
    func setupAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystem.Color.navBar
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .font: DesignSystem.Font.navigationTitle,
            .foregroundColor: DesignSystem.Color.textPrimary
        ]
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        tintColor = DesignSystem.Color.primary
        isTranslucent = false
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.14
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 6
    }
}
