//
//  ExamCard.swift
//  Gradeva
//
//  Created by Afga Ghifari on 20/08/25.
//

import SwiftUI


struct ExamCard: View {
    let exam: Exam
    let onTap: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.white.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appPrimary, lineWidth: 1)
            )
            .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
            .frame(height: 120)
            .overlay(
                VStack(spacing: 0) {
                    // MARK: Card Hero
                    VStack {
                        Spacer()
                        Text(exam.name)
                            .font(.title3.weight(.semibold))
                            .foregroundColor(Color.textPrimary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
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
                            Text("Start Grading")
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
            .onTapGesture(perform: onTap)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(exam.name) exam card")
            .accessibilityHint("Double tap to open exam: \(exam.name)")
            .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ExamCard(exam: Exam(name: "Theory"), onTap: {})
}
