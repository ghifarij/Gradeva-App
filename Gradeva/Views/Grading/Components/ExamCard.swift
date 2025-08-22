//
//  ExamCard.swift
//  Gradeva
//
//  Created by Afga Ghifari on 20/08/25.
//

import SwiftUI


struct ExamCard: View {
    @ObservedObject var navManager = NavManager.shared
    let title: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appPrimary, lineWidth: 1)
            )
            .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
            .frame(height: 160)
            .overlay(
                VStack(spacing: 0) {
                    // MARK: Card Hero
                    VStack {
                        Spacer()
                        Text(title)
                            .font(.title2.weight(.semibold))
                            .foregroundColor(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 12,
                            topTrailingRadius: 12
                        )
                    )
                    
                    // MARK: Action Hint
                    VStack {
                        Divider()
                        HStack {
                            Text("See more")
                                .foregroundColor(Color.textPrimary)
                                .font(.callout)
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color.textPrimary)
                                .font(.headline)
                                .accessibilityHidden(true)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        .padding(.bottom, 12)
                    }
                }
            )
            .onTapGesture {
                navManager.push(.exam(title))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(title) exam card")
            .accessibilityHint("Double tap to open exam: \(title)")
            .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ExamCard(title: "Theory")
}
