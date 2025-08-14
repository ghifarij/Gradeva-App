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
        "Spa",
        "Web Development",
        "Food & Beverage Services",
        "Public Speaking"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(subjects, id: \.self) { item in
                            GradingSubject(subjectName: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Grading")
        }
    }
}



#Preview {
    GradingView()
}
