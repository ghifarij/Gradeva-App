//
//  GradingView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingView: View {
    // TODO: Use grading model instead of hardcoded strings
    let subjects = [
        "Digital Marketing",
        "Hotel Operations",
        "Front Office Management",
        "English",
        "Spa",
        "Web Development",
        "Food & Beverage Services",
        "Public Speaking"
    ]
    
    // Define the grid layout with two flexible columns.
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(subjects, id: \.self) { subject in
                        GradingCard(title: subject)
                    }
                    .padding()
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Subjects list")
                }
                .accessibilityLabel("Grading subjects scroll view")
            }
            .navigationTitle("Grading")
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Grading screen")
        }
    }
}

#Preview {
    GradingView()
}

