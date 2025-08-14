//
//  GradingCard.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingCard: View {
    @EnvironmentObject var navManager: NavManager
    let title: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.secondary, lineWidth: 0.4)
            )
            .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
            .frame(height: 160)
            .overlay(
                VStack {
                    // MARK: Card Hero
                    VStack {
                        Spacer()
                        Text(title)
                            .font(.title2.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(.quaternary.opacity(0.2))
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
                            Text("Grading here")
                                .foregroundColor(.secondary)
                                .font(.callout)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                        .padding(.bottom, 12)
                    }
                }
            )
            .onTapGesture {
                navManager.push(.grading("some_ID"))
            }
    }
}

#Preview {
    GradingCard(title: "Exam 1")
}
