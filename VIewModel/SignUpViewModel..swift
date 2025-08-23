//import Foundation
//import FirebaseFirestore
//import FirebaseAuth
//import CoreLocation
//import MapKit
//
//@MainActor
//class SignUpViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var fullName = ""
//    @Published var userType: UserType = .buyer
//    @Published var email = ""
//    @Published var password = ""
//    @Published var confirmPassword = ""
//    @Published var errorMessage: String?
//    
//    @Published var location: CLLocationCoordinate2D?
//    @Published var selectedPlaceName: String?
//    @Published var nearbyCities: [String] = []
//    @Published var selectedCity: String?
//    
//    private let authService = AuthenticationService()
//    private let db = Firestore.firestore()
//    private let geocoder = CLGeocoder()
//
//    enum UserType: String, CaseIterable, Codable {
//        case buyer = "Buyer"
//        case seller = "Seller"
//    }
//
//    func signUp() {
//        errorMessage = nil
//        
//        guard !username.isEmpty, !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
//            errorMessage = "Please fill out all fields."
//            return
//        }
//        
//        guard password == confirmPassword else {
//            errorMessage = "Passwords do not match. Please try again."
//            return
//        }
//        
//        Task {
//            do {
//                let authResult = try await authService.signUp(withEmail: email, password: password, fullName: fullName)
//                try await createUserRecord(for: authResult.user)
//                
//                print("Successfully created user and saved data to Firestore.")
//                
//            } catch {
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//    
//    func reverseGeocodeLocation() {
//        guard let location = location else { return }
//        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//        
//        Task {
//            do {
//                let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
//                if let placemark = placemarks.first {
//                    self.selectedPlaceName = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.name ?? "Unknown Place"
//                }
//            } catch {
//                print("Error reverse geocoding location: \(error.localizedDescription)")
//                self.selectedPlaceName = "Could not find location name"
//            }
//        }
//    }
//    
//    func fetchNearbyCities() {
//        guard let location = location else { return }
//        
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = "city, town"
//        request.region = MKCoordinateRegion(center: location, latitudinalMeters: 50000, longitudinalMeters: 50000) // 50km radius
//        
//        let search = MKLocalSearch(request: request)
//        search.start { [weak self] (response, error) in
//            guard let self = self, let response = response else {
//                print("Error searching for nearby places: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            self.nearbyCities = response.mapItems.compactMap { $0.name }
//            if self.selectedCity == nil || !self.nearbyCities.contains(self.selectedCity ?? "") {
//                self.selectedCity = self.nearbyCities.first
//            }
//        }
//    }
//    
//    private func createUserRecord(for user: User) async throws {
//        var userData: [String: Any] = [
//            "uid": user.uid,
//            "username": username,
//            "fullName": fullName,
//            "email": email,
//            "userType": userType.rawValue,
//            "createdAt": Timestamp(date: Date())
//        ]
//        
//        if let location = location {
//            let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
//            userData["location"] = geoPoint
//        }
//        
//        if let selectedCity = selectedCity {
//            userData["selectedCity"] = selectedCity
//        }
//        
//        try await db.collection("users").document(user.uid).setData(userData)
//    }
//}
//
//extension CLLocationCoordinate2D: Equatable {
//    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
//        lhs.latitude == rhs.latitude && rhs.longitude == rhs.longitude
//    }
//}
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import MapKit

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var fullName = ""
    @Published var userType: UserType = .buyer
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    @Published var location: CLLocationCoordinate2D?
    @Published var selectedPlaceName: String?
    
    private let authService = AuthenticationService()
    private let db = Firestore.firestore()
    private let geocoder = CLGeocoder()

    enum UserType: String, CaseIterable, Codable {
        case buyer = "Buyer"
        case seller = "Seller"
    }

    func signUp() {
        errorMessage = nil
        
        guard !username.isEmpty, !fullName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill out all fields."
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match. Please try again."
            return
        }
        
        Task {
            do {
                let authResult = try await authService.signUp(withEmail: email, password: password, fullName: fullName)
                try await createUserRecord(for: authResult.user)
                
                print("Successfully created user and saved data to Firestore.")
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func reverseGeocodeLocation() {
        guard let location = location else { return }
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        Task {
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(clLocation)
                if let placemark = placemarks.first {
                    self.selectedPlaceName = placemark.locality ?? placemark.subAdministrativeArea ?? placemark.name ?? "Unknown Place"
                }
            } catch {
                print("Error reverse geocoding location: \(error.localizedDescription)")
                self.selectedPlaceName = "Could not find location name"
            }
        }
    }
    
    private func createUserRecord(for user: User) async throws {
        var userData: [String: Any] = [
            "uid": user.uid,
            "username": username,
            "fullName": fullName,
            "email": email,
            "userType": userType.rawValue,
            "createdAt": Timestamp(date: Date())
        ]
        
        if let location = location {
            let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
            userData["location"] = geoPoint
        }
        
        if let selectedPlaceName = selectedPlaceName {
            userData["selectedPlaceName"] = selectedPlaceName
        }
        
        try await db.collection("users").document(user.uid).setData(userData)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && rhs.longitude == rhs.longitude
    }
}
