//
//  StudentCard.swift
//  Gradeva
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

class StudentGrade: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    @Published var score: Int?
    
    init(name: String, score: Int? = nil) {
        self.name = name
        self.score = score
    }
}

struct StudentCardView: View {
    @ObservedObject var student: StudentGrade
    private let passingGrade = 80
    
    private var scoreText: Binding<String> {
        Binding(
            get: { student.score.map(String.init) ?? "" },
            set: { newValue in
                let digits = newValue.filter { $0.isNumber }
                student.score = digits.isEmpty ? nil : Int(digits)
            }
        )
    }
    
    private var indicatorColor: Color {
        guard let score = student.score else { return .gray }
        
        if score >= passingGrade {
            return .green
        } else {
            return .red
        }
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Capsule()
                .fill(indicatorColor)
                .frame(width: 6, height: 40)
            
            Text(student.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.textPrimary)
            
            Spacer()
            
            ZStack {
                if student.score == nil {
                    Text("--")
                        .foregroundStyle(.textPrimary.opacity(0.4))
                }
                TextField("", text: scoreText)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.textPrimary)
            }
            .frame(width: 60, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    .background(Color.white)
                    .cornerRadius(10)
            )
            
            Button(action: {
                // Add action for showing a comment sheet or view.
                print("Comment button tapped for \(student.name)")
            }) {
                Image(systemName: "message")
                    .font(.title2)
                    .foregroundColor(.textPrimary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

#Preview() {
    StudentCardView(
        student: StudentGrade(name: "Putri Tanjung", score: 80)
    )
}
