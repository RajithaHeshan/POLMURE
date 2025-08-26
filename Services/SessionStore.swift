import Foundation
import Combine
import FirebaseAuth

class SessionStore: ObservableObject {
    @Published var user: User?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    init() {
        print("SessionStore initialized.")
        self.authStateHandler = Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                print("SESSION: Firebase listener fired. User is SIGNED IN with UID: \(user.uid)")
            } else {
                print("SESSION: Firebase listener fired. User is SIGNED OUT.")
            }
            self.user = user
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

