import Foundation
import FirebaseFirestore

struct Offer: Identifiable {
    let id: String
    
    let sellerId: String
    let buyerId: String
    
    let buyerName: String
    let sellerName: String
    
    let offerAmount: Double
    let measure: String
    let offerDate: Timestamp
    let createdAt: Timestamp
    var status: OfferStatus
    
    // Manual initializer to create an Offer from a Firestore document
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.sellerId = data["sellerId"] as? String ?? ""
        self.buyerId = data["buyerId"] as? String ?? ""
        self.buyerName = data["buyerName"] as? String ?? ""
        self.sellerName = data["sellerName"] as? String ?? ""
        self.offerAmount = data["offerAmount"] as? Double ?? 0.0
        self.measure = data["measure"] as? String ?? ""
        self.offerDate = data["offerDate"] as? Timestamp ?? Timestamp()
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        
        // Safely decode the status enum
        if let statusString = data["status"] as? String, let status = OfferStatus(rawValue: statusString) {
            self.status = status
        } else {
            self.status = .pending
        }
    }
}

// The enum is still needed, but doesn't require the extra library
enum OfferStatus: String, Codable {
    case pending = "Pending"
    case cancelled = "Cancelled"
    case accepted = "Accepted"
    case declined = "Declined"
}
