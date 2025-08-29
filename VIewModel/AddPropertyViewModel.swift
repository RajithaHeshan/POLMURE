import SwiftUI
import MapKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class AddPropertyViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
   
    @Published var propertyName = ""
    @Published var sellerName = ""
    @Published var mobileNumber = ""
    @Published var estimateHarvestUnits = 3200
    @Published var nextHarvestDate = Date()
    
    
    @Published var location: CLLocationCoordinate2D?
    @Published var selectedPlaceName: String?
    
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var saveSuccess = false
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private let db = Firestore.firestore()
    private var geocodeDebounceTask: Task<Void, Never>?
    
    var propertyToEdit: Property?

    init(propertyToEdit: Property? = nil) {
        self.propertyToEdit = propertyToEdit
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if let property = propertyToEdit {
            populateFields(from: property)
        }
    }
    
    private func populateFields(from property: Property) {
        propertyName = property.propertyName
        sellerName = property.sellerName
        mobileNumber = property.mobileNumber
        estimateHarvestUnits = property.estimateHarvestUnits
        nextHarvestDate = property.nextHarvestDate.dateValue()
        location = CLLocationCoordinate2D(latitude: property.location.latitude, longitude: property.location.longitude)
        selectedPlaceName = property.cityName
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
            "createdAt": propertyToEdit?.createdAt ?? Timestamp(date: Date())
        ]
        
        if let documentId = propertyToEdit?.id {
            // Update existing document
            db.collection("properties").document(documentId).setData(propertyData, merge: true) { error in
                self.handleSaveResult(error: error, isEditing: true)
            }
        } else {
            // Add new document
            db.collection("properties").addDocument(data: propertyData) { error in
                self.handleSaveResult(error: error, isEditing: false)
            }
        }
    }
    
    private func handleSaveResult(error: Error?, isEditing: Bool) {
        self.isLoading = false
        if let error = error {
            self.alertMessage = "Failed to save property: \(error.localizedDescription)"
        } else {
            self.alertMessage = isEditing ? "Updated successfully!" : "Property saved successfully!"
            self.saveSuccess = true
        }
        self.showAlert = true
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
