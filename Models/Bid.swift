import Foundation
import FirebaseFirestore

enum BidStatus: String, Codable, CaseIterable {
    case pending = "Pending"
    case active = "Active"
    case cancelled = "Cancelled"
    case expired = "Expired"
}

struct Bid: Identifiable, Codable {
    var id: String?
    let propertyId: String
    let bidderId: String
    let bidderName: String
    let bidAmount: Double
    let measure: String
    let startDate: Timestamp
    let endDate: Timestamp
    let createdAt: Timestamp
    
    
    var status: BidStatus
}

