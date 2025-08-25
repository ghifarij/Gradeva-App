//
//  ExamCard.swift
//  Assessio
//
//  Created by Afga Ghifari on 20/08/25.
//

import SwiftUI


struct ExamCard: View {
    let exam: Exam
    let subjectId: String
    
    @ObservedObject var auth = AuthManager.shared
    @ObservedObject var navManager = NavManager.shared
    @ObservedObject private var examManager = ExamManager.shared
    
    var body: some View {
        Button(action: {
            if let schoolId = auth.currentUser?.schoolId {
                examManager.selectExam(schoolId: schoolId, subjectId: subjectId, exam: exam)
                navManager.push(.exam(exam.id ?? exam.name))
            }
        }) {
            VStack {
                Text(exam.name)
                    .padding()
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.2))
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 16,
                            topTrailingRadius: 16
                        )
                    )
                
                // MARK: Action Hint
                VStack {
                    HStack {
                        Text("Input Grade")
                            .foregroundColor(.white)
                            .font(.callout)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding()
                }
                .background(Color.appPrimary)
                .clipShape(
                    UnevenRoundedRectangle(
                        bottomLeadingRadius: 16,
                        bottomTrailingRadius: 16
                    )
                )
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appPrimary, lineWidth: 1)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(exam.name)
        .accessibilityHint("Double tap to start grading \(exam.name)")
    }
}

#Preview {
    ExamCard(exam: Exam(name: "Theory"), subjectId: "123")
}
