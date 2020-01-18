import UIKit
import Foundation

enum LocalNotificationsGroup {
    case newYear
    case panda
    
    func identifier() -> String {
        switch self {
        case .newYear:
            return "com.df.little-panda.newYearGroupID"
        default:
            return "com.df.little-panda.pandaGroupID"
        }
    }
}

enum Notifications {
    
    static let NotificationScreenKey = "screen"
    
    case showScreen(Screens)
    
    var name: Notification.Name {
        get {
            switch self {
            case .showScreen(_):
                return Notification.Name(rawValue: "ShowSpecificScreen")
            }
        }
    }
    
    func asNotification() -> Notification {
        switch self {
        case .showScreen(let screen):
            return Notification(name: name, object: nil, userInfo: [Notifications.NotificationScreenKey: screen])
        }
    }
}

protocol NotificationService {
    func requestAuthorization(_ handler: @escaping (Bool, Error?) -> Void)
    func schedule(_ group: LocalNotificationsGroup)
    func clear(_ group: LocalNotificationsGroup)
    func handle(_ response: UNNotificationResponse)
}

struct NotificationHandler: NotificationService {
    
    func requestAuthorization(_ handler: @escaping (Bool, Error?) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                handler(true, nil)
            case .denied:
                handler(false, nil)
            case .notDetermined:
                UNUserNotificationCenter
                    .current()
                    .requestAuthorization(options: [.alert, .badge], completionHandler: handler)
            @unknown default:
                break
            }
        }
        
    }
    
    func schedule(_ group: LocalNotificationsGroup) {
        switch group {
        case .newYear:
            scheduleNewYear()
        default:
            schedulePanda()
        }
    }
    
    func clear(_ group: LocalNotificationsGroup) {
        switch group {
        case .newYear:
            UNUserNotificationCenter
                .current()
                .removePendingNotificationRequests(withIdentifiers: [group.identifier()])
        default:
            UNUserNotificationCenter
                .current()
                .removePendingNotificationRequests(withIdentifiers: [group.identifier()])
        }
    }
    
    func handle(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            handleAction(response.notification)
        default:
            return
        }
    }
    
    private func handleAction(_ notification: UNNotification) {
        switch notification.request.identifier {
        case LocalNotificationsGroup.panda.identifier():
            NotificationCenter.default.post(Notifications.showScreen(.panda).asNotification())
        default:
            NotificationCenter.default.post(Notifications.showScreen(.timer).asNotification())
        }
    }
    
    private func schedulePanda() {
        let fireTime = Config.pandaAvailable.timeIntervalSince(Date())
        if fireTime < 0 {
            return
        }
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: fireTime, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Confidential!"
        content.subtitle = "[small panda eyes only]"
        content.body = "Charge completed. Energy capacity: 100%"
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: LocalNotificationsGroup.panda.identifier(),
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func scheduleNewYear() {
        for ntf in NewYearNotifications.fullList {
            UNUserNotificationCenter.current().add(ntf.formRequest(), withCompletionHandler: nil)
        }
    }
}
