//
//  HeaderCardView.swift
//  Assessio
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
            .padding()
            .padding(.top, 40) // image height
            .frame(maxWidth: .infinity)
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
