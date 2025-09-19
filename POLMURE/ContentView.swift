//import SwiftUI
//
//struct ContentView: View {
//    @EnvironmentObject var sessionStore: SessionStore
//    @Environment(\.scenePhase) var scenePhase
//    
//    var body: some View {
//        ZStack {
//            if let appUser = sessionStore.appUser {
//                switch appUser.userType {
//                case .buyer:
//                    BuyerHomePageView()
//                case .seller:
//                    SellerHomePageView()
//                }
//            } else {
//                LoginView()
//            }
//        }
//       
//        .onChange(of: scenePhase) { oldPhase, newPhase in
//            if newPhase == .background {
//                NotificationManager.instance.scheduleNotification()
//            }
//        }
//        
//    }
//}
//
//#Preview {
//    ContentView()
//        .environmentObject(SessionStore())
//}


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.scenePhase) var scenePhase
    
  
    @State private var isUnlocked = false
    private let authService = BiometricAuthService()
    
    var body: some View {
        ZStack {
            if isUnlocked {
                
                MainAppView()
            } else {
                
                LockScreenView(onAuthenticate: authenticateWithBiometrics)
            }
        }
        .onAppear(perform: authenticateWithBiometrics)
        .onChange(of: scenePhase) { oldPhase, newPhase in
           
            if newPhase == .inactive {
                isUnlocked = false
            }
           
            if newPhase == .active {
                authenticateWithBiometrics()
            }
        }
    }
    
    private func authenticateWithBiometrics() {
        // Don't re-prompt if already unlocked
        guard !isUnlocked else { return }
        
        Task {
            let success = await authService.authenticate()
            if success {
                isUnlocked = true
            }
        }
    }
}


struct MainAppView: View {
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        ZStack {
            if let appUser = sessionStore.appUser {
                switch appUser.userType {
                case .buyer:
                    BuyerHomePageView()
                case .seller:
                    SellerHomePageView()
                }
            } else {
                LoginView()
            }
        }
        .onChange(of: sessionStore.user) { oldUser, newUser in
            // This ensures that when a user logs out, they see the login screen,
            // and when they log in, they see the correct home page.
        }
    }
}


struct LockScreenView: View {
    var onAuthenticate: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Locked")
                .font(.title)
            
            Button("Unlock with Face ID", action: onAuthenticate)
                .buttonStyle(.bordered)
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(SessionStore())
}
