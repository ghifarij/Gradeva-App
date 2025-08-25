//
//  StudentCard.swift
//  Assessio
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

struct StudentCardView: View {
    @ObservedObject var student: StudentGrade
    let passingGrade: Double?
    let onScoreChange: (Double?) -> Void
    let onCommentTap: () -> Void
    let focusedStudent: FocusState<UUID?>.Binding
    @State private var isCommentExpanded = false
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private var isTextLarge: Bool {
        dynamicTypeSize > .xxLarge
    }
    
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
        student.draftComment.isEmpty ? .gray : .textPrimary
    }
    
    private func toggleExpanded() {
        withAnimation(.spring()) {
            isCommentExpanded.toggle()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            DynamicHStack {
                Capsule()
                    .fill(indicatorColor)
                    .if(!isTextLarge) {
                        $0.frame(width: 6, height: 40)
                    }
                    .if(isTextLarge) {
                        $0.frame(maxWidth: .infinity)
                        .frame(height: 10)
                    }
                    .accessibilityHidden(true)
                
                Text(student.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.textPrimary)
                    .accessibilityLabel(student.name)
                    .accessibilityHint("Double tap to open comments")
                    .accessibilityAction {
                        toggleExpanded()
                    }
                
                if !isTextLarge {
                    Spacer()
                }
                
                HStack {
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
                            .accessibilityLabel("Student's score")
                            .accessibilityHint("Double tap to input student's score")
                    }
                    .if(!isTextLarge) {
                        $0.frame(width: 60, height: 40)
                    }
                    .if(isTextLarge) {
                        $0.frame(height: 80)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            .background(Color.white)
                            .cornerRadius(10)
                    )
                    
                    Button(action: onCommentTap) {
                        Image(systemName: "message")
                            .font(.title2)
                            .foregroundColor(commentIconColor)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Input comment")
                    .accessibilityHint("Double tap to open comment input")
                }
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                toggleExpanded()
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(student.name)
            
            if isCommentExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    // Display the comment as text
                    Text(student.draftComment.isEmpty ? "No comment added." : student.draftComment)
                        .font(.callout)
                        .foregroundColor(student.draftComment.isEmpty ? .gray : .textPrimary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Comment about \(student.name)")
                .accessibilityAddTraits(.isStaticText)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .onChange(of: student.draftScore, {
            onScoreChange(student.draftScore)
        })
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
