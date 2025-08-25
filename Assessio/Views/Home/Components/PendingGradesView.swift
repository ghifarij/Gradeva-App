//
//  PendingGradesView.swift
//  Assessio
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct PendingGradesView: View {
    @ObservedObject private var subjectsManager = SubjectsManager.shared
    @ObservedObject private var navManager = NavManager.shared
    
    private var pendingReview: Int {
        subjectsManager.selectedSubject?.pendingReview ?? 0
    }
    
    private func goToReview() {
        if let subjectId = subjectsManager.selectedSubject?.id, let examId = subjectsManager.selectedSubject?.targetExamId {
            navManager.push([.grading(subjectId), .exam(examId)])
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pending Grades")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .accessibilityAddTraits(.isHeader)
            
            ZStack {
                VStack {
                    if pendingReview > 0 {
                        VStack {
                            Text("\(pendingReview) Awaiting")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                            Text("your review")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .fontWeight(.medium)
                        }
                        
                        Button(action: goToReview) {
                            Label("Grade here", systemImage: "clipboard")
                                .foregroundStyle(Color.appPrimary)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 30)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                        .accessibilityRemoveTraits(.isButton)
                        .accessibilityHidden(true)
                    } else {
                        Text("You're all set!")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .accessibilityLabel("No pending grades")
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(minHeight: 144)
            .background(.appCard)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .accessibilityElement(children: .combine)
            .if(pendingReview > 0) {
                $0
                    .accessibilityLabel("\(pendingReview) students awaiting your review")
                    .accessibilityHint("Double tap to grade")
                    .accessibilityAction {
                        goToReview()
                    }
            }
            .if(pendingReview == 0) {
                $0
                    .accessibilityLabel("You have reviewed all students in latest exam")
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PendingGradesView()
}
