//
//  MainTabView.swift
//  Gradeva
//
//  Created by Claude on 20/08/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                        .accessibilityLabel("Home tab")
                        .accessibilityHint("View dashboard and overview")
                }
            GradingView()
                .tabItem {
                    Label("Grading", systemImage: "pencil")
                        .accessibilityLabel("Grading tab")
                        .accessibilityHint("Grade student exams and assignments")
                }
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar")
                        .accessibilityLabel("Analytics tab")
                        .accessibilityHint("View performance statistics and reports")
                }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Main navigation tabs")
        .navigationDestination(for: NavPath.self) { path in
            switch path {
            case .settings:
                SettingsView()
            case .grading(let subjectId):
                ExamListView(subjectId: subjectId)
            case .exam(let examId):
                StudentGradingListView(examId: examId)
            case .profile:
                ProfileView()
            }
        }
        .onAppear {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(NavManager())
}
