

//import Foundation
//import FirebaseFirestore
//import CoreLocation
//
//struct AppUser: Identifiable, Codable {
//    let id: String
//    let username: String
//    let fullName: String
//    let email: String
//    let userType: UserType
//    let createdAt: Timestamp
//    
//    // These fields are optional because only buyers have them.
//    var location: GeoPoint?
//    var selectedPlaceName: String?
//    
//    // This is the new initializer that will fix the error.
//    init?(snapshot: DocumentSnapshot) {
//        guard let data = snapshot.data() else { return nil }
//        
//        self.id = snapshot.documentID
//        self.username = data["username"] as? String ?? ""
//        self.fullName = data["fullName"] as? String ?? ""
//        self.email = data["email"] as? String ?? ""
//        
//        if let userTypeString = data["userType"] as? String, let userType = UserType(rawValue: userTypeString) {
//            self.userType = userType
//        } else {
//            // Default to buyer or handle error if userType is missing/invalid
//            self.userType = .buyer
//        }
//        
//        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
//        self.location = data["location"] as? GeoPoint
//        self.selectedPlaceName = data["selectedPlaceName"] as? String
//    }
//}
//
//enum UserType: String, CaseIterable, Codable {
//    case buyer = "Buyer"
//    case seller = "Seller"
//}


import Foundation
import FirebaseFirestore
import CoreLocation

struct AppUser: Identifiable, Codable {
    let id: String
    let username: String
    let fullName: String
    let email: String
    let userType: UserType
    let createdAt: Timestamp
    let mobileNumber: String 
    var location: GeoPoint?
    var selectedPlaceName: String?
    
    // The initializer is updated to include the new mobileNumber field.
    init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else { return nil }
        
        self.id = snapshot.documentID
        self.username = data["username"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.mobileNumber = data["mobileNumber"] as? String ?? "" // Fetching the mobile number
        
        if let userTypeString = data["userType"] as? String, let userType = UserType(rawValue: userTypeString) {
            self.userType = userType
        } else {
            // Default to buyer or handle error if userType is missing/invalid
            self.userType = .buyer
        }
        
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.location = data["location"] as? GeoPoint
        self.selectedPlaceName = data["selectedPlaceName"] as? String
    }
}

enum UserType: String, CaseIterable, Codable {
    case buyer = "Buyer"
    case seller = "Seller"
}

