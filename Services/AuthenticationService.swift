import Foundation
import GoogleSignIn
import FirebaseAuth
import UIKit

enum AuthenticationError: Error {
    case controllerNotFound
    case signInFailed(Error)
    case credentialParsingFailed
    case firebaseSignInFailed(Error)
    case profileUpdateFailed(Error)
}

struct GoogleSignInResult {
    let idToken: String
    let accessToken: String
    let fullName: String?
    let email: String?
}

class AuthenticationService {

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
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: gidSignInResult.user.accessToken.tokenString)
            
            let firebaseAuthResult = try await Auth.auth().signIn(with: credential)
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
