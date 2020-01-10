import Foundation

extension Date {
    
    private static var tomorrow: Date? { return Date().dayAfter }
    private var dayAfter: Date? {
        if let midnight = midnight {
            return Calendar.current.date(byAdding: .day, value: 1, to: midnight)
        }
        return nil
    }
    private var midnight: Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    static func secondsToNewYear() -> TimeInterval {
        if let tomorrow = tomorrow {
            return Date().timeIntervalSince(tomorrow)
        }
        
        return 0
    }
    
    static func daysToNewYear() -> TimeInterval {
        if let newYear = findNewYear(),
            let tomorrow = tomorrow {
            return tomorrow.timeIntervalSince(newYear)
        }
        
        return 0
    }
    
    private static func findNewYear() -> Date? {
        let calendar: Calendar = Calendar.current
        
        let today: Date = Date()
        let unitFlags = Set<Calendar.Component>([.year])
        
        var components: DateComponents = calendar.dateComponents(unitFlags, from: today)
        
        components.day = 1
        components.month = 1
        components.year = calendar.component(.year, from: today) + 1
        
        return calendar.date(from: components)
    }
}
