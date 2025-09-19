import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.scenePhase) var scenePhase
    
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
       
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                NotificationManager.instance.scheduleNotification()
            }
        }
        
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionStore())
}
