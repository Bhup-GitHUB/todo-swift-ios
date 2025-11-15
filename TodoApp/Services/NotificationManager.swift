import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotification(for todo: TodoItem) {
        guard let dueDate = todo.dueDate, !todo.isCompleted else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Todo Reminder"
        content.body = todo.title
        content.sound = .default
        content.categoryIdentifier = "TODO_REMINDER"
        
        if !todo.notes.isEmpty {
            content.subtitle = todo.notes
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: todo.id.uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelNotification(for todo: TodoItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [todo.id.uuidString])
    }
    
    func updateNotification(for todo: TodoItem) {
        cancelNotification(for: todo)
        if !todo.isCompleted {
            scheduleNotification(for: todo)
        }
    }
}

