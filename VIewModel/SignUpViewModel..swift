import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var username = ""
    @Published var fullName = ""
    @Published var userType: UserType = .buyer
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    private let authService = AuthenticationService()
    private let db = Firestore.firestore()

    enum UserType: String, CaseIterable, Codable {
        case buyer = "Buyer"
        case seller = "Seller"
    }

    func signUp() {
        guard !username.isEmpty, !fullName.isEmpty, !email.isEmpty else {
            print("Error: All fields must be filled out.")
            return
        }
        
        guard password == confirmPassword else {
            print("Error: Passwords do not match.")
            return
        }
        
        Task {
            do {
                let authResult = try await authService.signUp(withEmail: email, password: password, fullName: fullName)
                try await createUserRecord(for: authResult.user)
                
                print("Successfully created user and saved data to Firestore.")
                
            } catch {
                print("Error during sign up: \(error.localizedDescription)")
            }
        }
    }
    
    private func createUserRecord(for user: User) async throws {
        let userData: [String: Any] = [
            "uid": user.uid,
            "username": username,
            "fullName": fullName,
            "email": email,
            "userType": userType.rawValue,
            "createdAt": Timestamp(date: Date())
        ]
        
        try await db.collection("users").document(user.uid).setData(userData)
    }
}

