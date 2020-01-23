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
    
    static func watchFaceUnitsTillNewYear() -> NSCalendar.Unit {
        let days = Int(-daysToNewYear() / 86400)
        if days > 31 {
            return .month
        } else if days > 1 {
            return .day
        } else {
            let seconds = -secondsToNewYear()
            if seconds > 3600 {
                return .hour
            } else {
                return .minute
            }
        }
    }
    
    func plusXHours(x: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: x, to: self) ?? Date()
    }
    
    func fractionToDate(_ date: Date, fullInterval: TimeInterval) -> Float {
        let left = date.timeIntervalSince(self)
        if left < 0 {
            return 1.0
        } else {
            return 1 - Float(left / fullInterval)
        }
    }
    
    static func findNewYear() -> Date? {
        let calendar: Calendar = Calendar.current
        
        let today: Date = Date()
        let unitFlags = Set<Calendar.Component>([.year])
        
        var components: DateComponents = calendar.dateComponents(unitFlags, from: today)
        
        components.day = 1
        components.month = 1
        components.year = calendar.component(.year, from: today) + 1
        
        return calendar.date(from: components)
    }
    
    static func fractionToNewYear() -> Float {
        guard let nyDate = findNewYear(), let lyDate = lastFirstJanuary() else {
            return 0.5
        }
        
        let fullYear = nyDate.timeIntervalSince(lyDate)
        let left = nyDate.timeIntervalSince(Date())
        
        return 1 - Float(left / fullYear)
    }
    
    private static func lastFirstJanuary() -> Date? {
        let calendar: Calendar = Calendar.current
        
        let today: Date = Date()
        let unitFlags = Set<Calendar.Component>([.year])
        
        var components: DateComponents = calendar.dateComponents(unitFlags, from: today)
        
        components.day = 1
        components.month = 1
        
        return calendar.date(from: components)
    }
}
