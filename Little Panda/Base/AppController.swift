import Foundation

struct AppController {
    
    static func launch() {
        let store = DIStore()
        store.register(RouterService(), type: Router.self)
        
        store.registerFactory { MainMenuViewModel() }
        store.registerFactory { TimerViewModel() }
        store.registerFactory { SettingsViewModel() }
        store.registerFactory { BackgroundSelectorViewModel() }
    }
}
