import UIKit

enum NewYearNotifications {
    
    static let fullList: [NewYearNotifications] = [
        .december1,
        .december10,
        .december17,
        .december24,
        .december30,
        .december31,
        .sixHours,
        .halfHour,
        .newYear
    ]
    
    case december1
    case december10
    case december17
    case december24
    case december30
    case december31
    case sixHours
    case halfHour
    case newYear
    case test(UNCalendarNotificationTrigger)
    
    func formRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        return UNNotificationRequest(identifier: LocalNotificationsGroup.newYear.identifier(),
                                     content: content,
                                     trigger: trigger)
    }
    
    private var body: String {
        switch self {
        case .december1:
            return "1st of December. Last month, New Year day is closing in!"
        case .december10:
            return "It's only 3 weeks left, out of 52 or whatever :) Coca Cola trucks are around the corner"
        case .december17:
            return "Two weeks left till New Year. Time to sent Santa a letter ;)"
        case .december24:
            return "Only one week left! One week till New Year. Main Panda declares holidays season open!"
        case .december30:
            return "I hope you're ready, because it's tomorrow! 1 day till New Year"
        case .december31:
            return "We waited for the whole year and it's today! Don't forget to get some sleep, Die Hard won't watch itself!"
        case .sixHours:
            return "Time to prepare salads and open light drinks! 6 hours and counting!"
        case .halfHour:
            return "30 minutes. No matter what happened and how hard this year was, what matters is Panda-team :)"
        case .newYear:
            return "You are woman of my life, my heart and soul. I love you more than anything. My sweet little panda :)"
        case .test(_):
            return "Notification body text"
            
        }
    }
    
    private var title: String {
        switch self {
        case .december1:
            return "Winter has come"
        case .december10:
            return "December 10"
        case .december17:
            return "December 17"
        case .december24:
            return "Almost Christmas!"
        case .december30:
            return "Just one more day"
        case .december31:
            return "Time is almost up"
        case .sixHours:
            return "T minus 6 hours"
        case .halfHour:
            return "Almost there!"
        case .newYear:
            return "HAPPY NEW YEAR!"
        case .test(_):
            return "TEST"
        }
    }
    
    private var trigger: UNCalendarNotificationTrigger {
        var components = DateComponents()
        components.month = 12
        components.hour = 15
        
        switch self {
        case .december1:
            components.day = 1
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .december10:
            components.day = 10
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .december17:
            components.day = 17
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .december24:
            components.day = 24
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .december30:
            components.day = 30
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .december31:
            components.day = 31
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .sixHours:
            components.day = 31
            components.hour = 18
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .halfHour:
            components.day = 31
            components.hour = 23
            components.minute = 30
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .newYear:
            components.day = 31
            components.hour = 23
            components.minute = 59
            components.second = 59
            return UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        case .test(let trigger):
            return trigger
        }
        
    }
}
