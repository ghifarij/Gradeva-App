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
    @StateObject private var auth = AuthManager()
    @StateObject private var navManager = NavManager()
    
    var body: some View {
        NavigationStack(path: $navManager.paths) {
            // Signed-in  --> show HomeView
            if auth.isSignedIn && auth.currentUser?.schoolId != nil {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    GradingView()
                        .tabItem {
                            Label("Grading", systemImage: "pencil")
                        }
                    AnalyticsView()
                        .tabItem {
                            Label("Analytics", systemImage: "chart.bar")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                }
                .navigationDestination(for: NavPath.self) { path in
                    switch path {
                    case .settings:
                        SettingsView()
                    case .grading(let examId):
                        GradingExamView(examId: examId)
                    }
                }
            } else if auth.isSignedIn {
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
