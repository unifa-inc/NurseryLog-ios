import RswiftResources
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        #if DEBUG
            guard !Application.isRunningUnitTests else { return }
        #endif

        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)

        guard
            let nav = R.storyboard.timelineViewController.instantiateInitialViewController() as? UINavigationController,
            let timelineVC = nav.viewControllers.first as? TimelineViewController
        else { return }

        timelineVC.viewModel = TimelineViewModel()
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
