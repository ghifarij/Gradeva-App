//
//  StudentListView.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import SwiftUI

struct StudentListView: View {
    let students: [StudentGrade]
    let passingGrade: Double?
    let focusedStudent: FocusState<UUID?>.Binding
    let onScoreChange: (String, Double?) -> Void
    let onCommentTap: (StudentGrade) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(students) { student in
                StudentCardView(
                    student: student,
                    passingGrade: passingGrade,
                    onScoreChange: { newScore in
                        onScoreChange(student.studentId, newScore)
                    },
                    onCommentTap: {
                        onCommentTap(student)
                    },
                    focusedStudent: focusedStudent
                )
            }
        }
        .accessibilityLabel("Students List")
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isHeader)
    }
}
