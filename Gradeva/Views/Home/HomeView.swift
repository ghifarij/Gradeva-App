//
//  HomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var navManager: NavManager
    
    private var user: AppUser? {
        auth.currentUser
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("homepage-bg")
                .scaledToFill()
            ScrollView {
                VStack(spacing: 16) {
                    HeaderCardView()
                    PendingGradesView()
                    SummaryView()
                }
                .padding(.top, 120)
                .padding(.bottom, 24)
                .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appPrimary)
        .ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthManager())
        .environmentObject(NavManager())
}

