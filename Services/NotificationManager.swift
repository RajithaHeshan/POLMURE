import Foundation
import UserNotifications

class NotificationManager {
    
   
    static let instance = NotificationManager()

    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS: Notification permissions granted.")
            }
        }
    }
    
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Come back to POLMURE!"
        content.subtitle = "There are new bids and offers waiting for you."
        content.sound = .default
        content.badge = 1
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
