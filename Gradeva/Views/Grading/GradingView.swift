//
//  GradingView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingView: View {
    @StateObject private var subjectsManager = SubjectsManager()

    // Define the grid layout with two flexible columns.
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                if let error = subjectsManager.errorMessage, !error.isEmpty {
                    InlineErrorView(message: error)
                        .padding(.horizontal)
                }

                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(subjectsManager.subjects, id: \.id) { subject in
                        GradingCard(subject: subject)
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Subjects list")
                }
                .padding()
                .accessibilityLabel("Grading subjects scroll view")
            }
            .navigationTitle("Subjects")
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Subject screen")
        }
    }
}

#Preview {
    GradingView()
}
