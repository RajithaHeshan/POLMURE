import SwiftUI

struct ContentView: View {
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
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionStore())
}
