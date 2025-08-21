//
//  HeaderCardView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct HeaderCardView: View {
    @EnvironmentObject var auth: AuthManager
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                Text(auth.currentUser?.displayName ?? "User")
                    .font(.callout)
                    .foregroundStyle(Color.appPrimary)
                
                Text("Digital Marketing")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appPrimary)
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "graduationcap.fill")
                        
                        Text("BATCH")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                            .fontWeight(.medium)
                        
                        Text("12")
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 1)
                        .padding(.vertical)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "person.3.fill")
                        
                        Text("STUDENTS")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                            .fontWeight(.medium)
                        
                        Text("28")
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(Color.appPrimary)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 240)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 32))
            
            Image("anakin")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipped()
                .clipShape(Circle())
                .offset(y: -50)
        }
    }
}

#Preview {
    HeaderCardView()
        .environmentObject(AuthManager())
}
