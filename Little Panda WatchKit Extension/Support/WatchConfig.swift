import Foundation
import UIKit

struct WatchConfig {
    
    @ConfigProperty(key: "panda_available", defaultValue: Date())
    static var pandaAvailable: Date
    
    @ConfigProperty(key: "initial_data_loaded", defaultValue: false)
    static var initialDataLoaded: Bool
    
    /**
     0 - watch face should display new year countdown
     1 - watch face should display panda re-charge
     default - 1
     */
    @ConfigProperty(key: "watch_face_timer", defaultValue: 1)
    static var watchFaceTimerIndex: Int
}
