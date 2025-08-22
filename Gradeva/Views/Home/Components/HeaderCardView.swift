//
//  HeaderCardView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct HeaderCardView: View {
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var navManager = NavManager.shared
    @ObservedObject var subjectsManager = SubjectsManager.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                
                SubjectNavigationView()
                
                BatchInfoView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            
            ProfileAvatarView()
                .offset(y: -50)
        }
    }
}

#Preview {
    HeaderCardView()
}
