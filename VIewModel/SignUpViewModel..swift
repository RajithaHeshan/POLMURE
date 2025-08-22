import Foundation
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

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
    
    private let authService = AuthenticationService()
    private let db = Firestore.firestore()

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
        
        try await db.collection("users").document(user.uid).setData(userData)
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

