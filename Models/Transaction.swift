//import Foundation
//import FirebaseFirestore
//
//struct Transaction: Identifiable, Codable {
//    let id: String
//    
//    let bidId: String
//    let propertyId: String
//    let buyerId: String
//    let sellerId: String
//    
//    let buyerName: String
//    let propertyName: String
//    
//    let bidAmount: Double
//    let measure: String
//    let estimatedHarvest: Int
//    
//    let createdAt: Timestamp
//    
//   
//    init?(document: DocumentSnapshot) {
//        guard let data = document.data() else { return nil }
//        
//        self.id = document.documentID
//        self.bidId = data["bidId"] as? String ?? ""
//        self.propertyId = data["propertyId"] as? String ?? ""
//        self.buyerId = data["buyerId"] as? String ?? ""
//        self.sellerId = data["sellerId"] as? String ?? ""
//        self.buyerName = data["buyerName"] as? String ?? ""
//        self.propertyName = data["propertyName"] as? String ?? ""
//        self.bidAmount = data["bidAmount"] as? Double ?? 0.0
//        self.measure = data["measure"] as? String ?? ""
//        self.estimatedHarvest = data["estimatedHarvest"] as? Int ?? 0
//        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
//    }
//}
//

import Foundation
import FirebaseFirestore

struct Transaction: Identifiable {
    let id: String
    
    let bidId: String
    let propertyId: String
    let buyerId: String
    let sellerId: String
    
    let buyerName: String
    let sellerName: String
    
    let propertyName: String
    
    let bidAmount: Double
    let measure: String
    let estimatedHarvest: Int
    
    let createdAt: Timestamp
    
   
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.bidId = data["bidId"] as? String ?? ""
        self.propertyId = data["propertyId"] as? String ?? ""
        self.buyerId = data["buyerId"] as? String ?? ""
        self.sellerId = data["sellerId"] as? String ?? ""
        self.buyerName = data["buyerName"] as? String ?? ""
        self.sellerName = data["sellerName"] as? String ?? "" 
        self.propertyName = data["propertyName"] as? String ?? ""
        self.bidAmount = data["bidAmount"] as? Double ?? 0.0
        self.measure = data["measure"] as? String ?? ""
        self.estimatedHarvest = data["estimatedHarvest"] as? Int ?? 0
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
    }
}
