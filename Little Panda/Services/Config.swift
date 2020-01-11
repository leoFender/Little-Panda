import Foundation
import UIKit

struct Config {
    
    @ConfigProperty(key: "panda_font", defaultValue: FontConfiguration.base())
    static var pandaFont: FontConfiguration
    
    @ConfigProperty(key: "timer_font", defaultValue: FontConfiguration.base())
    static var timerFont: FontConfiguration
    
    @ConfigProperty(key: "timer_notifications", defaultValue: true)
    static var timerNotification: Bool
    
    @ConfigProperty(key: "panda_notifications", defaultValue: true)
    static var pandaNotification: Bool
    
    @ConfigProperty(key: "timer_label_position", defaultValue: PositionConfiguration.base())
    static var timerLabelPosition: PositionConfiguration
    
    @ConfigProperty(key: "background_image_name", defaultValue: "Dark Circles")
    static var backgroundImageName: String
    
    @ConfigProperty(key: "is_custom_background", defaultValue: false)
    static var isCustomBackground: Bool
}
