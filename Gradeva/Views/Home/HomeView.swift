//
//  HomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var navManager = NavManager.shared
    
    private var user: AppUser? {
        auth.currentUser
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.appPrimary.ignoresSafeArea()
            Image("homepage-bg")
                .scaledToFill()
                .accessibilityHidden(true)
            ScrollView {
                VStack(spacing: 16) {
                    HeaderCardView()
                    PendingGradesView()
                    SummaryView()
                }
                .padding(.top, 150)
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            }
            .accessibilityLabel("Home screen content")
        }
        .ignoresSafeArea(.all, edges: .top)
        .accessibilityElement(children: .contain)
        .refreshable {
            await refreshData()
        }
        .task {
            await refreshData()
        }
        .accessibilityLabel("Home screen")
    }
    
    private func refreshData() async {
        guard let schoolId = auth.currentUser?.schoolId else { return }
        
        // Refresh school data which will trigger batch data refresh
        SubjectsManager.shared.loadSubjects(schoolId: schoolId)
        
        // Refetch subjects data
        SchoolManager.shared.startSchoolListener(schoolId: schoolId)
    }
}

#Preview {
    HomeView()
}

