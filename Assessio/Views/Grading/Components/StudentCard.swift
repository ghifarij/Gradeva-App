//
//  StudentCard.swift
//  Assessio
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

class StudentGrade: Identifiable, ObservableObject {
    let id = UUID()
    let studentId: String
    @Published var name: String
    // The score currently stored in backend (used for filtering/status)
    @Published var committedScore: Double?
    // The score being edited locally (used for TextField binding)
    @Published var draftScore: Double?
    @Published var comment: String = ""

    init(studentId: String, name: String, score: Double? = nil, comment: String = "") {
        self.studentId = studentId
        self.name = name
        self.committedScore = score
        self.draftScore = score
        self.comment = comment
    }
}

struct StudentCardView: View {
    @ObservedObject var student: StudentGrade
    let passingGrade: Double?
    let onScoreChange: (Double?) -> Void
    let onCommentTap: () -> Void
    let focusedStudent: FocusState<UUID?>.Binding
    @State private var isCommentExpanded = false
    
    private var scoreText: Binding<String> {
        Binding(
            get: {
                if let score = student.draftScore {
                    if floor(score) == score { return String(Int(score)) }
                    return String(score)
                }
                return ""
            },
            set: { newValue in
                // Allow digits and a single dot for decimals
                let filtered = newValue.filter { $0.isNumber || $0 == "." }
                // Avoid multiple dots
                let sanitized: String
                if filtered.components(separatedBy: ".").count > 2 {
                    // drop extra dots
                    var seenDot = false
                    sanitized = filtered.reduce(into: "") { acc, ch in
                        if ch == "." {
                            if !seenDot { acc.append(ch); seenDot = true }
                        } else {
                            acc.append(ch)
                        }
                    }
                } else {
                    sanitized = filtered
                }
                if sanitized.isEmpty {
                    student.draftScore = nil
                } else if let value = Double(sanitized) {
                    student.draftScore = value
                }
            }
        )
    }
    
    private var indicatorColor: Color {
        // Indicator reflects committed status, not the draft
        guard let score = student.committedScore, let passing = passingGrade else { return .gray }
        return score >= passing ? .green : .red
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
                    if student.draftScore == nil {
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
        .onChange(of: student.draftScore) { newValue in
            onScoreChange(newValue)
        }
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
                student: StudentGrade(studentId: "s1", name: "Putri Tanjung", score: 80),
                passingGrade: 80,
                onScoreChange: { _ in },
                onCommentTap: { print("Comment tapped") },
                focusedStudent: $focusedStudentID
            )
            StudentCardView(
                student: StudentGrade(
                    studentId: "s2",
                    name: "Ahmad Dhani",
                    score: 95
                ),
                passingGrade: 80,
                onScoreChange: { _ in },
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
