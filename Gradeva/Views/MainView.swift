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
    @StateObject private var launchManager = AppLaunchManager.shared
    @State private var showSplashScreen = true
    
    var didCompleteOnboarding: Bool {
        auth.currentUser?.didCompleteOnboarding ?? false
    }
    
    var didCompleteDemoOnboarding: Bool {
        auth.currentUser?.didCompleteDemoOnboarding ?? false
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
            ZStack {
                // Show splash screen on first launch for 1.5 seconds
                if showSplashScreen {
                    SplashScreenView()
                        .transition(.opacity) 
                        .onAppear(perform: hideSplashScreen)
                    // First launch - show welcome screen with login button
                } else if launchManager.isFirstLaunch {
                    FirstLaunchWelcomeView(onLoginTapped: {
                        launchManager.markAppAsLaunched()
                    })
                    .transition(.blurReplace)
                    // Signed-in and has school --> show main content
                } else if auth.isSignedIn && isAssignedToSchool {
                    if !didCompleteOnboarding {
                        WelcomeView()
                            .transition(.blurReplace)
                    } else {
                        MainTabView()
                            .transition(.blurReplace)
                    }
                } else if hasNoSchool {
                    NotRegisteredView()
                        .transition(.blurReplace)
                } else if !auth.isSignedIn {
                    // Not signed in --> show SignInView
                    SignInView()
                        .transition(.blurReplace)
                }
            }
            
        }
        .environmentObject(auth)
        .environmentObject(navManager)
    }
}

#Preview {
    MainContentView()
}
