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
    @Published var errorMessage: String?
    
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

