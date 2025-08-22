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
    @ObservedObject private var subjectsManager = SubjectsManager.shared
    @StateObject private var viewModel = HeaderCardViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                HStack {
                    Button(action: viewModel.goToPrevSubject) {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.appPrimary)
                    .clipShape(Circle())
                    .accessibilityLabel("Previous subject")
                    .accessibilityValue(viewModel.previousSubject?.name ?? "None")
                    .accessibilityHint("Double tap to switch to \(viewModel.previousSubject?.name ?? "previous subject")")
                    .accessibilityAddTraits(.isButton)
                    .disabled(!viewModel.canNavigateToPrevious)
                    .opacity(viewModel.canNavigateToPrevious ? 1.0 : 0.5)
                    
                    Spacer()
                    
                    VStack {
                        Text(auth.currentUser?.displayName ?? "User")
                            .font(.callout)
                            .foregroundStyle(Color.appPrimary)
                        
                        Text(subjectsManager.selectedSubject?.name ?? "-")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.appPrimary)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isStaticText)
                    .accessibilityLabel("Current subject")
                    .accessibilityValue(subjectsManager.selectedSubject?.name ?? "None")
                    .accessibilityAction(named: "Switch to \(viewModel.previousSubject?.name ?? "previous subject")", viewModel.goToPrevSubject)
                    .accessibilityAction(named: "Switch to \(viewModel.nextSubject?.name ?? "next subject")", viewModel.goToNextSubject)
                    
                    Spacer()
                    
                    Button(action: viewModel.goToNextSubject) {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.appPrimary)
                    .clipShape(Circle())
                    .accessibilityLabel("Next subject")
                    .accessibilityValue(viewModel.nextSubject?.name ?? "None")
                    .accessibilityHint("Double tap to switch to \(viewModel.nextSubject?.name ?? "next subject")")
                    .accessibilityAddTraits(.isButton)
                    .disabled(!viewModel.canNavigateToNext)
                    .opacity(viewModel.canNavigateToNext ? 1.0 : 0.5)
                }
                .padding(.horizontal)
                .onChange(of: viewModel.userSubjects.count, {
                    if viewModel.userSubjects.count > 0 {
                        subjectsManager.setSelectedSubject(viewModel.userSubjects.first)
                    }
                })
                
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
                        .background(Color.appPrimary)
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
        .environmentObject(NavManager.shared)
}
