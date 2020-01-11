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
        case .colorSelection:
            return "ColorPickerViewController"
        case .layoutSetup:
            return "TimerPositionSetupViewController"
        default:
            //TODO: placeholder
            return "MainMenuViewController"
        }
    }
}

protocol Router {
    func show(_ screen: Screens, from controller: UIViewController)
    func present(_ screen: Screens, from controller: UIViewController)
}

struct RouterService: Router {

    func show(_ screen: Screens, from controller: UIViewController) {
        controller.navigationController?.pushViewController(screen.asViewController(), animated: true)
    }
    
    func present(_ screen: Screens, from controller: UIViewController) {
        controller.show(screen.asViewController(), sender: nil)
    }
}
