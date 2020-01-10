import Foundation

extension DateComponentsFormatter {
    
    static func daysString(from interval: TimeInterval) -> String {
        let format = DateComponentsFormatter()
        format.unitsStyle = .short
        format.allowedUnits = [.month, .day]
        
        return format.string(from: interval) ?? "???"
    }
    
    static func hoursString(from interval: TimeInterval) -> String {
        let format = DateComponentsFormatter()
        format.unitsStyle = .positional
        format.allowedUnits = [.hour, .minute, .second]
        
        return format.string(from: interval) ?? "???"
    }
}
