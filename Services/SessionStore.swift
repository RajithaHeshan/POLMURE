//import Foundation
//import Combine
//import FirebaseAuth
//import FirebaseFirestore
//
//class SessionStore: ObservableObject {
//    @Published var appUser: AppUser?
//    
//    private var authStateHandler: AuthStateDidChangeListenerHandle?
//    private var userProfileListener: ListenerRegistration?
//    private let db = Firestore.firestore()
//    
//    init() {
//        print("SessionStore initialized.")
//        self.authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            guard let self = self else { return }
//            if let user = user {
//                print("SESSION: Firebase user is signed in with UID: \(user.uid)")
//                self.listenForUserProfile(for: user.uid)
//            } else {
//                print("SESSION: Firebase user is signed out.")
//                self.appUser = nil
//                self.userProfileListener?.remove()
//            }
//        }
//    }
//    
//    private func listenForUserProfile(for uid: String) {
//        userProfileListener?.remove()
//        
//        self.userProfileListener = db.collection("users").document(uid).addSnapshotListener { document, error in
//            if let error = error {
//                print("Error listening for user profile: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let document = document, document.exists else {
//                print("User profile document does not exist for UID: \(uid)")
//                return
//            }
//            
//            do {
//                self.appUser = try document.data(as: AppUser.self)
//                print("Successfully fetched and decoded user profile for type: \(self.appUser?.userType.rawValue ?? "N/A")")
//            } catch {
//                print("Error decoding user profile: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    func signOut() throws {
//        try Auth.auth().signOut()
//    }
//}
import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class SessionStore: ObservableObject {
    @Published var user: User?
    @Published var appUser: AppUser?

    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var userProfileListener: ListenerRegistration?

    init() {
        self.authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
            
            // When the auth state changes, we need to update our user profile listener.
            self?.setupUserProfileListener(for: user)
        }
    }
    
    deinit {
        // Clean up listeners when the SessionStore is no longer needed.
        authStateHandler.map(Auth.auth().removeStateDidChangeListener)
        userProfileListener?.remove()
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    private func setupUserProfileListener(for firebaseUser: User?) {
        // First, remove any existing listener to prevent duplicates.
        userProfileListener?.remove()
        
        guard let uid = firebaseUser?.uid else {
            // If there's no logged-in user, ensure our appUser is nil.
            self.appUser = nil
            return
        }

        // This is the key change: We now use a real-time snapshot listener.
        // This listener will fire immediately, and then it will fire again
        // automatically any time the user's document changes in Firestore.
        let userDocRef = Firestore.firestore().collection("users").document(uid)
        self.userProfileListener = userDocRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error listening for user profile changes: \(error.localizedDescription)")
                self.appUser = nil
                return
            }

            guard let document = documentSnapshot else {
                print("User profile document does not exist.")
                self.appUser = nil
                return
            }
            
            self.appUser = AppUser(snapshot: document)
            
            if self.appUser == nil {
                print("Failed to decode user profile from snapshot.")
            }
        }
    }
}
