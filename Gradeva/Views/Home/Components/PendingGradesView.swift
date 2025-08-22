//
//  PendingGradesView.swift
//  Gradeva
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Pending Grades")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .accessibilityAddTraits(.isHeader)
            
            ZStack {
                Image("pending-grades-bg")
                    .scaledToFill()
                    .accessibilityHidden(true)
                VStack {
                    if pendingReview > 0 {
                        VStack {
                            Text("\(pendingReview) awaiting")
                                .font(.title3)
                                .foregroundStyle(.white)
                            Text("your review")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(pendingReview) exams awaiting your review")
                        .accessibilityAddTraits(.isStaticText)
                        
                        Button(action: {
                            if let subjectId = subjectsManager.selectedSubject?.id, let examId = subjectsManager.selectedSubject?.targetExamid {
                                navManager.push([.grading(subjectId), .exam(examId)])
                            }
                        }) {
                            Label("Grade here", systemImage: "clipboard")
                                .foregroundStyle(Color.appPrimary)
                        }
                        .frame(minHeight: 44)
                        .frame(minWidth: 176)
                        .background(.white)
                        .clipShape(Capsule())
                        .accessibilityLabel("Grade pending exams")
                        .accessibilityHint("Double tap to start grading 6 pending exams")
                        .accessibilityAddTraits(.isButton)
                    } else {
                        Text("You're all set!")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .accessibilityLabel("No pending grades")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 144)
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PendingGradesView()
        .environmentObject(NavManager.shared)
}
