import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class SessionManager: ObservableObject {
    @Published var currentUser: User?
    
    private var db = Firestore.firestore()
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, authUser in
            guard let self = self else { return }
            
            if let authUser = authUser {
                self.fetchCurrentUser(uid: authUser.uid)
            } else {
                self.currentUser = nil
            }
        }
    }
    
    private func fetchCurrentUser(uid: String) {
        db.collection("users").document(uid).getDocument { document, error in
            guard let document = document, document.exists else {
                print("User document not found after login, which is unexpected.")
                return
            }
            
            do {
                self.currentUser = try document.data(as: User.self)
            } catch {
                print("Error decoding user document: \(error)")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
