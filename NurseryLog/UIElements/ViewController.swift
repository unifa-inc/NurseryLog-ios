import RswiftResources
import UIKit

class ViewController: UIViewController {
    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = DesignSystem.Color.background
        configureNavigationBar()
        bindData()
    }

    func bindData() {}

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = DesignSystem.Color.navBar
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .font: DesignSystem.Font.navigationTitle,
            .foregroundColor: DesignSystem.Color.textPrimary
        ]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = DesignSystem.Color.primary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.14
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        navigationController?.navigationBar.layer.shadowRadius = 6
    }
}

// MARK: - Push / Present

extension ViewController {
    func dispatchViewController(from resource: some StoryboardReference & InitialControllerContainer, with viewModel: ViewModel) -> ViewController? {
        guard let viewController = resource.instantiateInitialViewController() as? ViewController else {
            assertionFailure("Storyboard initial VC must be a ViewController subclass")
            return nil
        }
        viewController.viewModel = viewModel
        viewController.removeBackButtonTitle()
        return viewController
    }

    func pushViewController(from resource: some StoryboardReference & InitialControllerContainer, with viewModel: ViewModel) {
        guard let navigationController,
              let viewController = dispatchViewController(from: resource, with: viewModel) else { return }
        navigationController.pushViewController(viewController, animated: true)
    }

    func presentViewController(from resource: some StoryboardReference & InitialControllerContainer, with viewModel: ViewModel) {
        guard let viewController = dispatchViewController(from: resource, with: viewModel) else { return }
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
}
