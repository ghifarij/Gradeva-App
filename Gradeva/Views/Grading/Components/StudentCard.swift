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
    let onCommentTap: () -> Void
    let focusedStudent: FocusState<UUID?>.Binding
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
        student.comment.isEmpty ? .gray : .textPrimary
    }
    
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
                    }
                    TextField("", text: scoreText)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.textPrimary)
                        .focused(focusedStudent, equals: student.id)
                }
                .frame(width: 60, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        .background(Color.white)
                        .cornerRadius(10)
                )
                
                Button(action: {
                    onCommentTap()
                }) {
                    Image(systemName: "message")
                        .font(.title2)
                        .foregroundColor(commentIconColor)
                }
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring()) {
                    isCommentExpanded.toggle()
                }
            }
            
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

private struct StudentCardPreview: View {
    @FocusState private var focusedStudentID: UUID?

    var body: some View {
        VStack(spacing: 20) {
            StudentCardView(
                student: StudentGrade(name: "Putri Tanjung", score: 80),
                onCommentTap: { print("Comment tapped") },
                focusedStudent: $focusedStudentID
            )
            StudentCardView(
                student: StudentGrade(
                    name: "Ahmad Dhani",
                    score: 95
                ),
                onCommentTap: { print("Comment tapped") },
                focusedStudent: $focusedStudentID
            )
        }
        .padding()
    }
}

#Preview {
    StudentCardPreview()
}

