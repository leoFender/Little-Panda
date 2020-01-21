import Foundation

struct AppController {
    
    static func launch() {
        let store = DIStore()
        store.register(RouterService(), type: Router.self)
        store.register(NotificationHandler(), type: NotificationService.self)
        store.register(WatchConnectivityService(), type: WatchConnectivityProvider.self)
        
        store.registerFactory { MainMenuViewModel() }
        store.registerFactory { TimerViewModel() }
        store.registerFactory { SettingsViewModel() }
        store.registerFactory { BackgroundSelectorViewModel() }
        store.registerFactory { PandaViewModel() }
    }
}
