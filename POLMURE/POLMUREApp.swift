//
//  POLMUREApp.swift
//  POLMURE
//
//  Created by Heshan Dunumala on 2025-08-21.
//

//import SwiftUI
//
//@main
//struct POLMUREApp: App {
//    var body: some Scene {
//        WindowGroup {
//            LoginView()
//        }
//    }
//}


import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
  
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct POLMUREApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      LoginView()
    }
  }
}
