
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
    
    // These fields are optional because only buyers have them.
    var location: GeoPoint?
    var selectedPlaceName: String?
    
    // Standard initializer for creating instances, especially for previews.
    init(id: String, username: String, fullName: String, email: String, userType: UserType, createdAt: Timestamp, mobileNumber: String, location: GeoPoint?, selectedPlaceName: String?) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.email = email
        self.userType = userType
        self.createdAt = createdAt
        self.mobileNumber = mobileNumber
        self.location = location
        self.selectedPlaceName = selectedPlaceName
    }
    
    // Initializer for creating an instance from a Firestore document.
    init?(snapshot: DocumentSnapshot) {
        guard let data = snapshot.data() else { return nil }
        
        self.id = snapshot.documentID
        self.username = data["username"] as? String ?? ""
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.mobileNumber = data["mobileNumber"] as? String ?? ""
        
        if let userTypeString = data["userType"] as? String, let userType = UserType(rawValue: userTypeString) {
            self.userType = userType
        } else {
            self.userType = .buyer
        }
        
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.location = data["location"] as? GeoPoint
        self.selectedPlaceName = data["selectedPlaceName"] as? String
    }
    
    // Shared mock object for previews.
    static var mock: AppUser {
        AppUser(
            id: "mockUserID",
            username: "sadul_p",
            fullName: "Sadul Perera",
            email: "sadul@example.com",
            userType: .buyer,
            createdAt: Timestamp(date: Date()),
            mobileNumber: "071107161",
            location: GeoPoint(latitude: 7.2906, longitude: 80.6337),
            selectedPlaceName: "Warakapola"
        )
    }
}

enum UserType: String, CaseIterable, Codable {
    case buyer = "Buyer"
    case seller = "Seller"
}

