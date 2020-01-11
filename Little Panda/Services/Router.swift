import UIKit

enum Screens {
    case menu
    case timer
    case panda
    case settings
    case backgroundSelection
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
        default:
            //TODO: placeholder
            return "MainMenuViewController"
        }
    }
}

protocol Router {
    func show(_ screen: Screens, from controller: BaseViewController)
    func present(_ screen: Screens, from controller: BaseViewController)
}

struct RouterService: Router {

    func show(_ screen: Screens, from controller: BaseViewController) {
        controller.navigationController?.pushViewController(screen.asViewController(), animated: true)
    }
    
    func present(_ screen: Screens, from controller: BaseViewController) {
        controller.show(screen.asViewController(), sender: nil)
    }
}
