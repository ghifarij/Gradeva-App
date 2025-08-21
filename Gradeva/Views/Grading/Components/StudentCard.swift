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
    @Published var comment: String = ""
    
    init(name: String, score: Int? = nil, comment: String = "") {
        self.name = name
        self.score = score
        self.comment = comment
    }
}

struct StudentCardView: View {
    @ObservedObject var student: StudentGrade
    private let passingGrade = 80
    @State private var isCommentExpanded = false
    
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
    
    private var commentIconColor: Color {
        isCommentExpanded ? .textPrimary : .gray
    }
    
    //    private var accessibilityScoreValue: String {
    //        if let score = student.score {
    //            let status = score >= passingGrade ? "Passing" : "Needs assist"
    //            return "Score \(score), \(status)"
    //        } else {
    //            return "Not graded"
    //        }
    //    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                Capsule()
                    .fill(indicatorColor)
                    .frame(width: 6, height: 40)
                    .accessibilityHidden(true)
                
                Text(student.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.textPrimary)
                
                Spacer()
                
                ZStack {
                    if student.score == nil {
                        Text("--")
                            .foregroundStyle(.textPrimary.opacity(0.4))
                        //                        .accessibilityHidden(true)
                    }
                    TextField("", text: scoreText)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.textPrimary)
                    //                    .accessibilityLabel("Score for \(student.name)")
                    //                    .accessibilityHint("Double tap to edit score")
                    //                    .accessibilityValue(student.score.map(String.init) ?? "Not graded")
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
                    withAnimation(.spring()) {
                        isCommentExpanded.toggle()
                    }
                }) {
                    Image(systemName: "message")
                        .font(.title2)
                        .foregroundColor(commentIconColor)
                }
                //            .accessibilityLabel("Comment for \(student.name)")
                //            .accessibilityHint("Double tap to add or view a comment")
                //            .accessibilityAddTraits(.isButton)
            }
            .padding()
            
            if isCommentExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    // Display the comment as text
                    Text(student.comment.isEmpty ? "No comment added." : student.comment)
                        .font(.callout)
                        .foregroundColor(student.comment.isEmpty ? .gray : .textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        //        .accessibilityElement(children: .combine)
        //        .accessibilityLabel(student.name)
        //        .accessibilityValue(accessibilityScoreValue)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .center,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

#Preview() {
    StudentCardView(
        student: StudentGrade(name: "Putri Tanjung", score: 80, comment: "Good job")
    )
}
