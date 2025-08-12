//
//  GradevaApp.swift
//  Gradeva
//
//  Created by Afga Ghifari on 08/08/25.
//

import SwiftUI
import FirebaseCore

// Your existing AppDelegate for Firebase configuration is correct.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct GradevaApp: App {
    // Connect the AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // A state variable to track the authentication status
    @State private var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            MainContentView()
        }
    }
}
