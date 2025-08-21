//
//  HeaderCardView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct HeaderCardView: View {
    @EnvironmentObject var auth: AuthManager
    @EnvironmentObject var navManager: NavManager
    @ObservedObject private var schoolManager = SchoolManager.shared
    @ObservedObject private var batchManager = BatchManager.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                Text(auth.currentUser?.displayName ?? "User")
                    .font(.callout)
                    .foregroundStyle(Color.appPrimary)
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel("Name")
                    .accessibilityValue(auth.currentUser?.displayName ?? "User")
                
                Text("Digital Marketing")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.appPrimary)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityLabel("Subject")
                    .accessibilityValue("Digital Marketing")
                
                HStack {
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "graduationcap.fill")
                        
                        Text("BATCH")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                            .fontWeight(.medium)
                        
                        Text(batchManager.currentBatch?.name ?? "-")
                            .fontWeight(.bold)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Current active batch")
                    .accessibilityValue("Batch \(batchManager.currentBatch?.name ?? "unknown")")
                    .accessibilityAddTraits(.isStaticText)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(.white.opacity(0.3))
                        .frame(width: 1)
                        .padding(.vertical)
                        .accessibilityHidden(true)
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Image(systemName: "person.3.fill")
                        
                        Text("STUDENTS")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                            .fontWeight(.medium)
                        
                        Text("\(batchManager.studentCount)")
                            .fontWeight(.bold)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Total students in active batch")
                    .accessibilityValue("\(batchManager.studentCount) students")
                    .accessibilityAddTraits(.isStaticText)
                    
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
            
            Button(action: {
                navManager.push(.profile)
            }) {
                ZStack(alignment: .bottomTrailing) {
                    Image(auth.currentUser?.avatar ?? "avatar-1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipped()
                        .clipShape(Circle())
                    
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .font(.system(size: 12, weight: .medium))
                        .frame(width: 24, height: 24)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .offset(x: -4, y: -4)
                }
            }
            .offset(y: -50)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Profile picture")
            .accessibilityHint("Double tap to view profile")
        }
    }
}

#Preview {
    HeaderCardView()
        .environmentObject(AuthManager())
        .environmentObject(NavManager())
}
