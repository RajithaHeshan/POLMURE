//import Foundation
//import FirebaseFirestore
//
//struct Property: Identifiable, Codable {
//    @DocumentID var id: String?
//    let ownerId: String
//    let propertyName: String
//    let address: String
//    let sellerName: String
//    let mobileNumber: String
//    let estimateHarvestUnits: Int
//    let nextHarvestDate: Timestamp
//    let location: GeoPoint
//    let cityName: String
//    let createdAt: Timestamp
//
//    var daysUntilNextHarvest: Int {
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        let harvestDay = calendar.startOfDay(for: nextHarvestDate.dateValue())
//        let components = calendar.dateComponents([.day], from: today, to: harvestDay)
//        return components.day ?? 0
//    }
//}
//

import Foundation
import FirebaseFirestore

struct Property: Identifiable, Codable {
    @DocumentID var id: String?
    let ownerId: String
    let propertyName: String
    let sellerName: String
    let mobileNumber: String
    let estimateHarvestUnits: Int
    let nextHarvestDate: Timestamp
    let location: GeoPoint
    let cityName: String
    let createdAt: Timestamp

    var daysUntilNextHarvest: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let harvestDay = calendar.startOfDay(for: nextHarvestDate.dateValue())
        let components = calendar.dateComponents([.day], from: today, to: harvestDay)
        return components.day ?? 0
    }
}
