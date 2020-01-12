import UIKit

enum Screens {
    case menu
    case timer
    case panda
    case settings
    case backgroundSelection
    case zoomBackground(String)
    case layoutSetup
    case colorSelection
    
    func asViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(identifier: storyboardID())
    }
    
    private func storyboardID() -> String {
        switch self {
        case .menu:
            return "MainMenuViewController"
        case .timer:
            return "TimerViewController"
        case .settings:
            return "SettingsViewController"
        case .colorSelection:
            return "ColorPickerViewController"
        case .layoutSetup:
            return "TimerPositionSetupViewController"
        case .backgroundSelection:
            return "BackgroundViewController"
        case .zoomBackground(_):
            return "ZoomPreviewViewController"
        default:
            //TODO: placeholder
            return "MainMenuViewController"
        }
    }
}

protocol Router {
    func show(_ screen: Screens, from controller: UIViewController)
    func present(_ screen: Screens, from controller: UIViewController)
    func zoom(_ screen: Screens,
              from controller: UIViewController,
              with transitionController: ZoomTransitionController)
}

struct RouterService: Router {

    func show(_ screen: Screens, from controller: UIViewController) {
        controller.navigationController?.pushViewController(screen.asViewController(), animated: true)
    }
    
    func present(_ screen: Screens, from controller: UIViewController) {
        controller.show(screen.asViewController(), sender: nil)
    }
    
    func zoom(_ screen: Screens,
              from controller: UIViewController,
              with transitionController: ZoomTransitionController) {
        
        let toVC = screen.asViewController()
        switch screen {
        case .zoomBackground(let image):
            (toVC as? ZoomPreviewViewController)?.imageName = image
        default:
            return
        }
        
        let navController = controller.navigationController
        navController?.delegate = transitionController
        
        if let toVC = toVC as? ZoomAnimatorDelegate,
            let fromVC = controller as? ZoomAnimatorDelegate {
            
            transitionController.fromDelegate = fromVC
            transitionController.toDelegate = toVC
        }
        
        controller.navigationController?.pushViewController(toVC, animated: true)
    }
}
