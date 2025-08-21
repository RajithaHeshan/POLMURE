import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    private let authService = AuthenticationService()

    func login() {
        print("Login button tapped")
    }
    
    func createAccount() {
        print("Navigate to create account")
    }
    
    func forgotPassword() {
        print("Forgot password tapped")
    }

    func signInWithGoogle() {
        Task {
            do {
                let result = try await authService.signInWithGoogle()
                
                print("Successfully signed in with Firebase.")
                print("User: \(result.user.displayName ?? "N/A")")
                print("Email: \(result.user.email ?? "N/A")")
                print("Firebase UID: \(result.user.uid)")
                
            } catch {
                print("Error during Google Sign-In with Firebase: \(error.localizedDescription)")
            }
        }
    }
}

