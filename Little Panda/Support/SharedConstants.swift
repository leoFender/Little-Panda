import Foundation

struct SharedConstants {
    
    static let rechargeTime: TimeInterval = 86400
    static let onePercentTimeInterval: TimeInterval = SharedConstants.rechargeTime / 100
    static let updateUIWatchNotificationName = NSNotification.Name("UpdateUIWatchNotification")
}
