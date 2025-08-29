import Foundation
import FirebaseFirestore

struct Property: Identifiable, Codable {
    var id: String
    var ownerId: String
    var propertyName: String
    var sellerName: String
    var mobileNumber: String
    var estimateHarvestUnits: Int
    var nextHarvestDate: Timestamp
    var location: GeoPoint
    var cityName: String
    var createdAt: Timestamp
    
    var daysUntilNextHarvest: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let harvestDay = calendar.startOfDay(for: nextHarvestDate.dateValue())
        let components = calendar.dateComponents([.day], from: today, to: harvestDay)
        return components.day ?? 0
    }
    
    init?(snapshot: QueryDocumentSnapshot) {
        let data = snapshot.data()
        
        guard
            let ownerId = data["ownerId"] as? String,
            let propertyName = data["propertyName"] as? String,
            let sellerName = data["sellerName"] as? String,
            let mobileNumber = data["mobileNumber"] as? String,
            let estimateHarvestUnits = data["estimateHarvestUnits"] as? Int,
            let nextHarvestDate = data["nextHarvestDate"] as? Timestamp,
            let location = data["location"] as? GeoPoint,
            let cityName = data["cityName"] as? String,
            let createdAt = data["createdAt"] as? Timestamp
        else {
            return nil
        }
        
        self.id = snapshot.documentID
        self.ownerId = ownerId
        self.propertyName = propertyName
        self.sellerName = sellerName
        self.mobileNumber = mobileNumber
        self.estimateHarvestUnits = estimateHarvestUnits
        self.nextHarvestDate = nextHarvestDate
        self.location = location
        self.cityName = cityName
        self.createdAt = createdAt
    }
}

