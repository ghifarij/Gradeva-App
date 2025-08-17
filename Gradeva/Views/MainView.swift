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
    
    // Track onboarding state
    @State private var showSchoolAssignedOnboarding = false
    @State private var lastSchoolId: String? = nil
    @State private var registrationId: String? = nil

    var body: some View {
        NavigationStack(path: $navManager.paths) {
            // If not signed in
            if !auth.isSignedIn {
                SignInView()
            }
            // If signed in and not assigned to a school (first login)
            else if auth.isSignedIn && (auth.currentUser?.schoolId == nil || auth.currentUser?.schoolId == "") {
                // Show onboarding for registration
                if let regId = registrationId ?? auth.currentUser?.id {
                    FirstTimeRegistrationOnboardingView(registrationId: regId)
                } else {
                    ProgressView("Loading...")
                }
                Button("Sign Out") {
                    auth.signOut()
                }
            }
            // If just assigned to a school (show onboarding once)
            else if auth.isSignedIn && auth.currentUser?.schoolId != nil && showSchoolAssignedOnboarding {
                SchoolAssignedOnboardingView(schoolName: auth.currentUser?.schoolId ?? "Your School")
                Button("Continue") {
                    showSchoolAssignedOnboarding = false
                }
            }
            // Normal signed-in state
            else if auth.isSignedIn && auth.currentUser?.schoolId != nil {
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
            }
        }
        .onChange(of: auth.currentUser?.schoolId) { newSchoolId in
            // If user just got assigned to a school, show onboarding
            if let newId = newSchoolId, newId != lastSchoolId, lastSchoolId == nil {
                showSchoolAssignedOnboarding = true
            }
            lastSchoolId = newSchoolId
        }
        .onAppear {
            // Set registrationId for onboarding (simulate, as backend is not integrated)
            if registrationId == nil, let userId = auth.currentUser?.id {
                registrationId = userId
            }
            lastSchoolId = auth.currentUser?.schoolId
        }
        .environmentObject(auth)
        .environmentObject(navManager)
    }
}

#Preview {
    MainContentView()
}
