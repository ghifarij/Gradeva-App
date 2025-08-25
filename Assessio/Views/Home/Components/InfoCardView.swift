//
//  InfoCardView.swift
//  Assessio
//
//  Created by Afga Ghifari on 15/08/25.
//

import SwiftUI

struct InfoCardView: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white.opacity(0.8))
            Text("\(count)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .background(Color.gray)
        .cornerRadius(20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityValue("\(count)")
        .accessibilityHint("Summary card")
        .accessibilityAddTraits(.isStaticText)
    }
}
