//import FirebaseFirestore
//import FirebaseAuth
//import CoreLocation
//import MapKit
//import SwiftUI
//
//@MainActor
//class SignUpViewModel: ObservableObject {
//    @Published var username = ""
//    @Published var fullName = ""
//    @Published var userType: UserType = .buyer {
//        didSet {
//            updateProfileImageForUserType()
//        }
//    }
//    @Published var email = ""
//    @Published var password = ""
//    @Published var confirmPassword = ""
//    @Published var errorMessage: String?
//    
//    @Published var location: CLLocationCoordinate2D?
//    @Published var selectedPlaceName: String?
//    
//    @Published var profileImage: Image?
//    private var profileImageData: Data?
//    
//    private let authService = AuthenticationService()
//    private let db = Firestore.firestore()
//    private let geocoder = CLGeocoder()
//    
//    // The UserType enum has been removed from here.
//    // It now uses the one from AppUser.swift
//    
//    init() {
//        updateProfileImageForUserType()
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
//    private func updateProfileImageForUserType() {
//        var imageName: String?
//        
//        switch userType {
//        case .buyer:
//            imageName = "Buyer"
//        case .seller:
//            imageName = "seller"
//        }
//        
//        if let name = imageName, let uiImage = UIImage(named: name) {
//            profileImage = Image(uiImage: uiImage)
//            profileImageData = uiImage.jpegData(compressionQuality: 0.8)
//        } else {
//            profileImage = nil
//            profileImageData = nil
//            if let name = imageName {
//                print("Warning: \(name).jpg not found in asset catalog.")
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
//        if let location = location, userType == .buyer {
//            let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
//            userData["location"] = geoPoint
//        }
//        
//        if let selectedPlaceName = selectedPlaceName, userType == .buyer {
//            userData["selectedPlaceName"] = selectedPlaceName
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

import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation
import MapKit
import SwiftUI

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var fullName = ""
    @Published var mobileNumber = "" 
    @Published var userType: UserType = .buyer {
        didSet {
            updateProfileImageForUserType()
        }
    }
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    @Published var location: CLLocationCoordinate2D?
    @Published var selectedPlaceName: String?
    
    @Published var profileImage: Image?
    private var profileImageData: Data?
    
    private let authService = AuthenticationService()
    private let db = Firestore.firestore()
    private let geocoder = CLGeocoder()

    init() {
        updateProfileImageForUserType()
    }

    func signUp() {
        errorMessage = nil
        
        // Updated guard to include mobileNumber
        guard !username.isEmpty, !fullName.isEmpty, !mobileNumber.isEmpty, !email.isEmpty, !password.isEmpty else {
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
    
    private func updateProfileImageForUserType() {
        var imageName: String?
        
        switch userType {
        case .buyer:
            imageName = "Buyer"
        case .seller:
            imageName = "seller"
        }
        
        if let name = imageName, let uiImage = UIImage(named: name) {
            profileImage = Image(uiImage: uiImage)
            profileImageData = uiImage.jpegData(compressionQuality: 0.8)
        } else {
            profileImage = nil
            profileImageData = nil
            if let name = imageName {
                print("Warning: \(name).jpg not found in asset catalog.")
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
            "mobileNumber": mobileNumber, // Saving mobile number to Firestore
            "userType": userType.rawValue,
            "createdAt": Timestamp(date: Date())
        ]
        
        if let location = location, userType == .buyer {
            let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
            userData["location"] = geoPoint
        }
        
        if let selectedPlaceName = selectedPlaceName, userType == .buyer {
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
