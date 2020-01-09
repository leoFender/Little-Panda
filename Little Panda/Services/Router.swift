import UIKit

enum Screens {
    case menu
    case timer
    case panda
    case settings
    case fontSelection
    case layoutSetup
    
    func asViewController() -> BaseViewController {
        return MainMenuViewController()
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
