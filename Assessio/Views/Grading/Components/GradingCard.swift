//
//  GradingCard.swift
//  Assessio
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI


struct GradingCard: View {
    @ObservedObject var navManager = NavManager.shared
    let subject: Subject
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appPrimary, lineWidth: 1)
            )
            .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
            .frame(height: 160)
            .overlay(
                VStack(spacing: 0) {
                    // MARK: Card Hero
                    VStack {
                        Spacer()
                        Text(subject.name)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .accessibilityAddTraits(.isHeader)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            topTrailingRadius: 16
                        )
                    )
                    
                    // MARK: Action Hint
                    VStack {
                        Divider()
                        HStack {
                            Text("See more")
                                .foregroundColor(.white)
                                .font(.callout)
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.headline)
                                .accessibilityHidden(true)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        .padding(.bottom, 12)
                    }
                    .background(Color.appPrimary)
                    .clipShape(
                        UnevenRoundedRectangle(
                            bottomLeadingRadius: 16,
                            bottomTrailingRadius: 16
                        )
                    )
                }
            )
            .onTapGesture {
                navManager.push(.grading(subject.id ?? subject.name))
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(subject.name) grading card")
            .accessibilityHint("Double tap to open grading for \(subject.name)")
            .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    GradingCard(subject: Subject(name: "Digital Marketing"))
        .environmentObject(NavManager.shared)
}
