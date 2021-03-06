import Foundation
import UIKit

class SettingsViewModel {
    
    @Injected var notifications: NotificationService
    @Injected var watchConnection: WatchConnectivityProvider
    
    func newFontSelected(_ font: UIFont, `for` screen: Screens) {
        var current: FontConfiguration
        switch screen {
        case .panda:
            current = Config.pandaFont
        default:
            current = Config.timerFont
        }
        
        let new = FontConfiguration(name: font.fontName, size: current.size, rgbColor: current.rgbColor)
        
        switch screen {
        case .panda:
            Config.pandaFont = new
        default:
            Config.timerFont = new
        }
    }
    
    func newSizeSelected(_ size: CGFloat) {
        let current = Config.timerFont
        let new = FontConfiguration(name: current.name, size: size, rgbColor: current.rgbColor)
        Config.timerFont = new
    }
    
    func newColorSelected(_ color: UIColor, `for` screen: Screens) {
        var current: FontConfiguration
        switch screen {
        case .panda:
            current = Config.pandaFont
        default:
            current = Config.timerFont
        }
        
        let newRGB = color.rgb()
        let newColor = ColorConfiguration(red: newRGB.red,
                                          green: newRGB.green,
                                          blue: newRGB.blue,
                                          alpha: newRGB.alpha)
        
        let new = FontConfiguration(name: current.name, size: current.size, rgbColor: newColor)
        Config.pandaFont = new
    }
    
    func toggleNotifications(_ screen: Screens, completion: @escaping () -> Void) {
        notifications.requestAuthorization { [weak self] granted, error in
            if error != nil {
                print(error!)
            } else {
                if granted {
                    switch screen {
                    case .panda:
                        self?.togglePandaNotifications()
                    default:
                        self?.toggleCountdownNotifications()
                    }
                }
            }
            
            completion()
        } // requestAuth
    } // func
    
    func selectWatchTimerDisplay(_ index: Int) {
        let model: TransferModel = .complicationIndex(index)
        watchConnection.pushComplicationInfo(model)
        
        Config.watchFaceTimerIndex = index
    }
}

extension SettingsViewModel {
    
    private func togglePandaNotifications() {
        let current = !Config.pandaNotification
        Config.pandaNotification = current
        if current {
            notifications.schedule(.panda)
        } else {
            notifications.clear(.panda)
        }
    }
    
    private func toggleCountdownNotifications() {
        let current = !Config.timerNotification
        Config.timerNotification = current
        if current {
            notifications.schedule(.newYear)
        } else {
            notifications.clear(.newYear)
        }
    }
}

