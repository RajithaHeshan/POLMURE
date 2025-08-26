

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//  LoginView()
//}


//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//  LoginView()
//}


//import SwiftUI
//
//struct ContentView: View {
//    @EnvironmentObject var sessionStore: SessionStore
//    
//    var body: some View {
//        if sessionStore.user != nil {
//            SellerHomePageView()
//        } else {
//            LoginView()
//        }
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
