import Foundation
import UIKit

class SettingsViewModel {
    
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
    
    func toggleNotifications(_ screen: Screens) {
        switch screen {
        case .panda:
            Config.pandaNotification = !Config.pandaNotification
        default:
            Config.timerNotification = !Config.timerNotification
        }
    }
}

