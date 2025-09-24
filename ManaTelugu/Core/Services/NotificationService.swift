import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
    func requestAuthorization(completion: @escaping (Bool) -> Void)
    func scheduleDailyReminder(hour: Int, minute: Int, title: String, body: String)
    func cancelAll()
}

final class NotificationService: NotificationServiceProtocol {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func scheduleDailyReminder(hour: Int, minute: Int, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily_learning_reminder", content: content, trigger: trigger)

        center.add(request, withCompletionHandler: nil)
    }

    func cancelAll() { center.removeAllPendingNotificationRequests() }
}


