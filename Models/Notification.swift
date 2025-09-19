import Foundation
import FirebaseFirestore

enum NotificationType: String, Codable {
    case newBid = "New Bid"
    case newOffer = "New Offer"
    case offerAccepted = "Offer Accepted"

}

struct AppNotification: Identifiable, Codable {
    let id: String
    let recipientId: String
    let type: NotificationType
    let title: String
    let message: String
    let isRead: Bool
    let createdAt: Timestamp
    
   
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.recipientId = data["recipientId"] as? String ?? ""
        self.title = data["title"] as? String ?? ""
        self.message = data["message"] as? String ?? ""
        self.isRead = data["isRead"] as? Bool ?? false
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        
        if let typeString = data["type"] as? String, let type = NotificationType(rawValue: typeString) {
            self.type = type
        } else {
            return nil // A notification must have a valid type
        }
    }
}
