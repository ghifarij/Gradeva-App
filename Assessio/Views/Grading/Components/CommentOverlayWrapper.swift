//
//  CommentOverlayWrapper.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import SwiftUI

struct CommentOverlayWrapper: View {
    @Binding var showingCommentFor: StudentGrade?
    let originalDraftComment: String
    let onSave: (StudentGrade) -> Void
    let onCancel: (StudentGrade) -> Void
    
    var body: some View {
        if let student = showingCommentFor {
            CommentOverlayView(
                comment: Binding(
                    get: { student.draftComment },
                    set: { student.draftComment = $0 }
                ),
                isShowing: Binding(
                    get: { showingCommentFor != nil },
                    set: { _ in }
                ),
                studentName: student.name,
                onSave: {
                    onSave(student)
                },
                onCancel: {
                    onCancel(student)
                }
            )
        }
    }
}