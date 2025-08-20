//
//  MainContentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 12/08/25.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct MainContentView: View {
    @ObservedObject private var auth = AuthManager.shared
    @StateObject private var navManager = NavManager()
    @State private var showSplashScreen = true
    
    var didCompleteOnboarding: Bool {
        auth.currentUser?.didCompleteOnboarding ?? false
    }
    
    var isAssignedToSchool: Bool {
        auth.currentUser?.schoolId != nil
    }
    
    var hasNoSchool: Bool {
        !isAssignedToSchool && auth.isSignedIn
    }
    
    private func hideSplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSplashScreen = false
            }
        }
    }
    
    var body: some View {
        NavigationStack(path: $navManager.paths) {
            // Show splash screen on first launch for 1.5 seconds
            if showSplashScreen {
                SplashScreenView()
                    .transition(.blurReplace)
                    .onAppear(perform: hideSplashScreen)
            // Signed-in  --> show HomeView
            } else if auth.isSignedIn && isAssignedToSchool {
                ZStack {
                    if !didCompleteOnboarding {
                        WelcomeView()
                            .transition(.blurReplace)
                    } else {
                        MainTabView()
                            .transition(.blurReplace)
                    }
                }
            } else if hasNoSchool {
                NotRegisteredView()
            } else {
                // Not signed in --> show SignInView
                SignInView()
            }
            
        }
        .environmentObject(auth)
        .environmentObject(navManager)
    }
}

#Preview {
    MainContentView()
}
