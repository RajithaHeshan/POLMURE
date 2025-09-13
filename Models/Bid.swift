//import Foundation
//import FirebaseFirestore
//
//struct Bid: Identifiable, Codable {
//    var id: String?
//    let propertyId: String
//    let bidderId: String
//    let bidderName: String
//    let bidAmount: Double
//    let measure: String 
//    let startDate: Timestamp
//    let endDate: Timestamp
//    let createdAt: Timestamp
//}

import Foundation
import FirebaseFirestore

struct Bid: Identifiable, Codable {
    var id: String?
    let propertyId: String
    let bidderId: String
    let bidderName: String
    let bidAmount: Double
    let measure: String // "Per Unit" or "Per Kilo"
    let startDate: Timestamp
    let endDate: Timestamp
    let createdAt: Timestamp
}
