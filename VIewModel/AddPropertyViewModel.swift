//import SwiftUI
//import MapKit
//import CoreLocation
//import FirebaseFirestore
//import FirebaseAuth
//
//@MainActor
//class AddPropertyViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
//    // Form State
//    @Published var propertyName = "warakapola1"
//    @Published var address = ""
//    @Published var sellerName = ""
//    @Published var mobileNumber = ""
//    @Published var estimateHarvestUnits = 3200
//    @Published var nextHarvestDate = Date()
//    
//    // Location State
//    @Published var location: CLLocationCoordinate2D?
//    @Published var selectedPlaceName: String?
//    
//    // Saving State
//    @Published var isLoading = false
//    @Published var showAlert = false
//    @Published var alertMessage = ""
//    @Published var saveSuccess = false
//    
//    private let locationManager = CLLocationManager()
//    private let geocoder = CLGeocoder()
//    private let db = Firestore.firestore()
//    private var geocodeDebounceTask: Task<Void, Never>?
//
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//
//    func saveProperty(userId: String) {
//        isLoading = true
//        saveSuccess = false
//
//        let propertyData: [String: Any] = [
//            "ownerId": userId,
//            "propertyName": propertyName,
//            "address": address,
//            "sellerName": sellerName,
//            "mobileNumber": mobileNumber,
//            "estimateHarvestUnits": estimateHarvestUnits,
//            "nextHarvestDate": Timestamp(date: nextHarvestDate),
//            "location": GeoPoint(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0),
//            "cityName": selectedPlaceName ?? "N/A",
//            "createdAt": Timestamp(date: Date())
//        ]
//        
//        db.collection("properties").addDocument(data: propertyData) { error in
//            self.isLoading = false
//            if let error = error {
//                self.alertMessage = "Failed to save property: \(error.localizedDescription)"
//            } else {
//                self.alertMessage = "Property saved successfully!"
//                self.saveSuccess = true
//            }
//            self.showAlert = true
//        }
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .authorizedWhenInUse, .authorizedAlways:
//            manager.requestLocation()
//        case .notDetermined:
//            manager.requestWhenInUseAuthorization()
//        case .denied, .restricted:
//            self.selectedPlaceName = "Location access denied."
//        @unknown default:
//            break
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else { return }
//        self.location = location.coordinate
//        reverseGeocodeLocation()
//    }
//    
//    func reverseGeocodeLocation() {
//        guard let location = self.location else { return }
//        
//        geocodeDebounceTask?.cancel()
//        geocodeDebounceTask = Task {
//            do {
//                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
//                let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//                if let placemarks = try? await geocoder.reverseGeocodeLocation(clLocation),
//                   let placemark = placemarks.first {
//                    self.selectedPlaceName = placemark.locality ?? placemark.name ?? "Unknown Place"
//                } else {
//                    self.selectedPlaceName = "Could not determine city"
//                }
//            } catch {
//                print("Geocode task cancelled")
//            }
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to get user location: \(error.localizedDescription)")
//        self.selectedPlaceName = "Location unavailable"
//    }
//}


import SwiftUI
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AddPropertyViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Form State
    @Published var propertyName = "warakapola1"
    @Published var sellerName = ""
    @Published var mobileNumber = ""
    @Published var estimateHarvestUnits = 3200
    @Published var nextHarvestDate = Date()
    
    // Location State
    @Published var location: CLLocationCoordinate2D?
    @Published var selectedPlaceName: String?
    
    // Saving State
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var saveSuccess = false
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let db = Firestore.firestore()
    private var geocodeDebounceTask: Task<Void, Never>?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func saveProperty(userId: String) {
        isLoading = true
        saveSuccess = false

        let propertyData: [String: Any] = [
            "ownerId": userId,
            "propertyName": propertyName,
            "sellerName": sellerName,
            "mobileNumber": mobileNumber,
            "estimateHarvestUnits": estimateHarvestUnits,
            "nextHarvestDate": Timestamp(date: nextHarvestDate),
            "location": GeoPoint(latitude: location?.latitude ?? 0, longitude: location?.longitude ?? 0),
            "cityName": selectedPlaceName ?? "N/A",
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("properties").addDocument(data: propertyData) { error in
            self.isLoading = false
            if let error = error {
                self.alertMessage = "Failed to save property: \(error.localizedDescription)"
            } else {
                self.alertMessage = "Property saved successfully!"
                self.saveSuccess = true
            }
            self.showAlert = true
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            self.selectedPlaceName = "Location access denied."
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location.coordinate
        reverseGeocodeLocation()
    }
    
    func reverseGeocodeLocation() {
        guard let location = self.location else { return }
        
        geocodeDebounceTask?.cancel()
        geocodeDebounceTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                if let placemarks = try? await geocoder.reverseGeocodeLocation(clLocation),
                   let placemark = placemarks.first {
                    self.selectedPlaceName = placemark.locality ?? placemark.name ?? "Unknown Place"
                } else {
                    self.selectedPlaceName = "Could not determine city"
                }
            } catch {
                print("Geocode task cancelled")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        self.selectedPlaceName = "Location unavailable"
    }
}
