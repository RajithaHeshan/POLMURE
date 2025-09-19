
import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var notifications: [AppNotification] = []
    @Published var hasUnreadNotifications = false
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        fetchNotifications()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchNotifications() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        listener = db.collection("notifications")
            .whereField("recipientId", isEqualTo: userId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching notifications: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                
                self.notifications = documents.compactMap { AppNotification(document: $0) }
                self.checkForUnreadNotifications()
                self.isLoading = false
            }
    }
    
    func markAsRead(notification: AppNotification) {
        guard !notification.isRead else { return }
        
        db.collection("notifications").document(notification.id).updateData(["isRead": true])
    }
    
    private func checkForUnreadNotifications() {
        
        self.hasUnreadNotifications = self.notifications.contains { !$0.isRead }
    }
}
