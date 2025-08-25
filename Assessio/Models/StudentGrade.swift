//
//  StudentGrade.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import Foundation

class StudentGrade: Identifiable, ObservableObject {
    let id = UUID()
    let studentId: String
    @Published var name: String
    // The score currently stored in backend (used for filtering/status)
    @Published var committedScore: Double?
    // The score being edited locally (used for TextField binding)
    @Published var draftScore: Double?
    // The comment currently stored in backend
    @Published var committedComment: String
    // The local draft comment
    @Published var draftComment: String

    init(studentId: String, name: String, score: Double? = nil, comment: String = "") {
        self.studentId = studentId
        self.name = name
        self.committedScore = score
        self.draftScore = score
        self.committedComment = comment
        self.draftComment = comment
    }
}