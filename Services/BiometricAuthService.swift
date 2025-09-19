import Foundation
import LocalAuthentication

class BiometricAuthService {
    
    private let context = LAContext()
    private let policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics
    private let reason = "Please authenticate to securely access your account."

    
    func authenticate() async -> Bool {
        
        guard context.canEvaluatePolicy(policy, error: nil) else {
            print("ERROR: Biometrics not available on this device.")
            return false
        }
        
        do {
            let success = try await context.evaluatePolicy(policy, localizedReason: reason)
            return success
        } catch {
            print("ERROR: Biometric authentication failed: \(error.localizedDescription)")
            return false
        }
    }
}

