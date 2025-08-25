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
        Button(action: {
            if let subjectId = subject.id {
                navManager.push(.grading(subjectId))
            }
        }) {
            VStack {
                Text(subject.name)
                    .padding()
                    .padding(.vertical)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)
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
                    HStack {
                        Text("See more")
                            .foregroundColor(.white)
                            .font(.callout)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                }
                .background(Color.appPrimary)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 16
                    )
                )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appPrimary, lineWidth: 1)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(subject.name)
        .accessibilityHint("Double tap to grade \(subject.name)")
    }
}

#Preview {
    GradingCard(subject: Subject(name: "Digital Marketing"))
        .environmentObject(NavManager.shared)
}
