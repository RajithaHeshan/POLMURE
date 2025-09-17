import Foundation
import FirebaseFirestore

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
}


//import Foundation
//import FirebaseFirestore
//
//struct Bid: Identifiable {
//    let id: String
//    let propertyId: String
//    let bidderId: String
//    let bidderName: String
//    let bidAmount: Double
//    let measure: String
//    let startDate: Timestamp
//    let endDate: Timestamp
//    let createdAt: Timestamp
//
//
//    init?(snapshot: QueryDocumentSnapshot) {
//        let data = snapshot.data()
//        guard
//            let propertyId = data["propertyId"] as? String,
//            let bidderId = data["bidderId"] as? String,
//            let bidderName = data["bidderName"] as? String,
//            let bidAmount = data["bidAmount"] as? Double,
//            let measure = data["measure"] as? String,
//            let startDate = data["startDate"] as? Timestamp,
//            let endDate = data["endDate"] as? Timestamp,
//            let createdAt = data["createdAt"] as? Timestamp
//        else {
//            return nil
//        }
//
//        self.id = snapshot.documentID
//        self.propertyId = propertyId
//        self.bidderId = bidderId
//        self.bidderName = bidderName
//        self.bidAmount = bidAmount
//        self.measure = measure
//        self.startDate = startDate
//        self.endDate = endDate
//        self.createdAt = createdAt
//    }
//}
//
