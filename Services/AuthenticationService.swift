//import Foundation
//import GoogleSignIn
//import FirebaseAuth
//import UIKit
//
//enum AuthenticationError: Error {
//    case controllerNotFound
//    case signInFailed(Error)
//    case credentialParsingFailed
//    case firebaseSignInFailed(Error)
//    case profileUpdateFailed(Error)
//}
//
//struct GoogleSignInResult {
//    let idToken: String
//    let accessToken: String
//    let fullName: String?
//    let email: String?
//}
//
//class AuthenticationService {
//
//    @MainActor
//    func signInWithGoogle() async throws -> AuthDataResult {
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let rootViewController = windowScene.windows.first?.rootViewController else {
//            throw AuthenticationError.controllerNotFound
//        }
//
//        do {
//            let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            
//            guard let idToken = gidSignInResult.user.idToken?.tokenString else {
//                throw AuthenticationError.credentialParsingFailed
//            }
//            
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                         accessToken: gidSignInResult.user.accessToken.tokenString)
//            
//            let firebaseAuthResult = try await Auth.auth().signIn(with: credential)
//            return firebaseAuthResult
//            
//        } catch {
//            throw AuthenticationError.signInFailed(error)
//        }
//    }
//
//    func signUp(withEmail email: String, password: String, fullName: String) async throws -> AuthDataResult {
//        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        
//        let changeRequest = authResult.user.createProfileChangeRequest()
//        changeRequest.displayName = fullName
//        
//        do {
//            try await changeRequest.commitChanges()
//        } catch {
//            throw AuthenticationError.profileUpdateFailed(error)
//        }
//        
//        return authResult
//    }
//    
//    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
//        do {
//            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
//            return authResult
//        } catch {
//            throw AuthenticationError.firebaseSignInFailed(error)
//        }
//    }
//}
//
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import UIKit

enum AuthenticationError: Error {
    case controllerNotFound
    case signInFailed(Error)
    case credentialParsingFailed
    case firebaseSignInFailed(Error)
    case profileUpdateFailed(Error)
}

class AuthenticationService {

    private let db = Firestore.firestore()

    @MainActor
    func signInWithGoogle() async throws -> AuthDataResult {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw AuthenticationError.controllerNotFound
        }

        do {
            let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = gidSignInResult.user.idToken?.tokenString else {
                throw AuthenticationError.credentialParsingFailed
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: gidSignInResult.user.accessToken.tokenString)
            
            let firebaseAuthResult = try await Auth.auth().signIn(with: credential)
            
            let user = firebaseAuthResult.user
            let userDocRef = db.collection("users").document(user.uid)
            let document = try await userDocRef.getDocument()

            if !document.exists {
                print("First-time Google Sign-In for user: \(user.uid). Creating profile...")
                
                let userData: [String: Any] = [
                    "id": user.uid,
                    "uid": user.uid,
                    "username": user.email?.split(separator: "@").first.map(String.init) ?? "",
                    "fullName": user.displayName ?? "New User",
                    "email": user.email ?? "",
                    "userType": UserType.seller.rawValue, // THIS IS THE UPDATED LINE
                    "createdAt": Timestamp(date: Date()),
                    "mobileNumber": user.phoneNumber ?? ""
                ]
                
                try await userDocRef.setData(userData)
                print("User profile created successfully.")
            }
            
            return firebaseAuthResult
            
        } catch {
            throw AuthenticationError.signInFailed(error)
        }
    }

    func signUp(withEmail email: String, password: String, fullName: String) async throws -> AuthDataResult {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = fullName
        
        do {
            try await changeRequest.commitChanges()
        } catch {
            throw AuthenticationError.profileUpdateFailed(error)
        }
        
        return authResult
    }
    
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return authResult
        } catch {
            throw AuthenticationError.firebaseSignInFailed(error)
        }
    }
}
