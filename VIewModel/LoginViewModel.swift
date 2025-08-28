import Foundation
import FirebaseAuth

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService = AuthenticationService()

    func login() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await authService.signIn(withEmail: email, password: password)
                print("Successfully signed in with email. UID: \(result.user.uid)")
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func createAccount() {
        print("Navigate to create account")
    }
    
    func forgotPassword() {
        print("Forgot password tapped")
    }

    func signInWithGoogle() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await authService.signInWithGoogle()
                print("Successfully signed in with Firebase. UID: \(result.user.uid)")
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
}
