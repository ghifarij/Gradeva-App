//
//  GradingSubject.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingSubject: View {
    let subjectName: String
    let gradingItems = [
        "Exam 1",
        "Exam 2",
        "Practical 1",
        "Practical 2",
        "Interview",
        "Final Exam"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(subjectName)
                .font(.title3.bold())
            VStack(spacing: 12) {
                ForEach(gradingItems, id: \.self) { item in
                    GradingCard(title: item)
                }
            }
        }
    }
}

#Preview {
    GradingSubject(subjectName: "Digital Marketing")
}
