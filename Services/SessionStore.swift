//import Foundation
//import Combine
//import FirebaseAuth
//import FirebaseFirestore
//
//class SessionStore: ObservableObject {
//    @Published var appUser: AppUser?
//    
//    private var authStateHandler: AuthStateDidChangeListenerHandle?
//    private let db = Firestore.firestore()
//    
//    init() {
//        print("SessionStore initialized.")
//        self.authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            guard let self = self else { return }
//            if let user = user {
//                print("SESSION: Firebase user is signed in with UID: \(user.uid)")
//                self.fetchUserProfile(for: user.uid)
//            } else {
//                print("SESSION: Firebase user is signed out.")
//                self.appUser = nil
//            }
//        }
//    }
//    
//    private func fetchUserProfile(for uid: String) {
//        db.collection("users").document(uid).getDocument { document, error in
//            if let error = error {
//                print("Error fetching user profile: \(error.localizedDescription)")
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

class SessionStore: ObservableObject {
    @Published var appUser: AppUser?
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    private var userProfileListener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    init() {
        print("SessionStore initialized.")
        self.authStateHandler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                print("SESSION: Firebase user is signed in with UID: \(user.uid)")
                self.listenForUserProfile(for: user.uid)
            } else {
                print("SESSION: Firebase user is signed out.")
                self.appUser = nil
                self.userProfileListener?.remove()
            }
        }
    }
    
    private func listenForUserProfile(for uid: String) {
        userProfileListener?.remove()
        
        self.userProfileListener = db.collection("users").document(uid).addSnapshotListener { document, error in
            if let error = error {
                print("Error listening for user profile: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists else {
                print("User profile document does not exist for UID: \(uid)")
                return
            }
            
            do {
                self.appUser = try document.data(as: AppUser.self)
                print("Successfully fetched and decoded user profile for type: \(self.appUser?.userType.rawValue ?? "N/A")")
            } catch {
                print("Error decoding user profile: \(error.localizedDescription)")
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
