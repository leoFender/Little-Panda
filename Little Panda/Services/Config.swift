import Foundation
import UIKit

struct Config {
    
    @ConfigProperty(key: "panda_font", defaultValue: FontConfiguration.base())
    static var pandaFont: FontConfiguration
    
    @ConfigProperty(key: "timer_font", defaultValue: FontConfiguration.base())
    static var timerFont: FontConfiguration
    
    @ConfigProperty(key: "timer_notifications", defaultValue: false)
    static var timerNotification: Bool
    
    @ConfigProperty(key: "panda_notifications", defaultValue: false)
    static var pandaNotification: Bool
    
    @ConfigProperty(key: "timer_label_position", defaultValue: PositionConfiguration.base())
    static var timerLabelPosition: PositionConfiguration
    
    @ConfigProperty(key: "background_image_name", defaultValue: "Small Panda")
    static var backgroundImageName: String
    
    @ConfigProperty(key: "is_custom_background", defaultValue: false)
    static var isCustomBackground: Bool
    
    @ConfigProperty(key: "last_panda_entry", defaultValue: -1)
    static var lastPandaEntry: Int
    
    @ConfigProperty(key: "panda_available", defaultValue: Date())
    static var pandaAvailable: Date
    
    @ConfigProperty(key: "emergency_available", defaultValue: Date())
    static var emergencyAvailable: Date
    
    /**
     0 - watch face should display new year countdown
     1 - watch face should display panda re-charge
     default - 1
     */
    @ConfigProperty(key: "watch_face_timer", defaultValue: 1)
    static var watchFaceTimerIndex: Int
}
