import UIKit

class BaseViewController: UIViewController {

    @Injected var router: Router
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseViewController.handle(_:)),
                                               name: Notifications.showScreen(.menu).name, // .menu is irrelevant, check implementation
                                               object: nil)
    }
    
    @objc private func handle(_ notification: NSNotification) {
        guard let screen = notification.userInfo?[Notifications.NotificationScreenKey] as? Screens else {
            return
        }
        if self.restorationIdentifier != screen.storyboardID() {
            router.show(screen, from: self)
        }
    }
}

class BaseTableViewController: UITableViewController {
    
    @Injected var router: Router
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(BaseTableViewController.handle(_:)),
                                               name: Notifications.showScreen(.menu).name,
                                               object: nil)
    }
    
    @objc private func handle(_ notification: NSNotification) {
        guard let screen = notification.userInfo?[Notifications.NotificationScreenKey] as? Screens else {
            return
        }
        if self.restorationIdentifier != screen.storyboardID() {
            router.show(screen, from: self)
        }
    }
}
