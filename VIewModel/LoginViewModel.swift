import Foundation

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""

    func login() {
        print("Login button tapped")
    }
    
    func createAccount() {
        print("Navigate to create account")
    }
    
    func forgotPassword() {
        print("Forgot password tapped")
    }
    
    func signInWithApple() {
        print("Sign in with Apple tapped")
    }
    
    func signInWithGoogle() {
        print("Sign in with Google tapped")
    }
}
