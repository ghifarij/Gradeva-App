//
//  ExamModel.swift
//  Assessio
//
//  Created by Ramdan on 19/08/25.
//

import Foundation
import FirebaseFirestore

class Exam: Codable {
    @DocumentID var id: String?
    var name: String
    var maxScore: Double?
    var passingScore: Double?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    var pendingReview: Int?
    var totalStudentsPassed: Int?
    var totalStudentsFailed: Int?
    
    init(id: String? = nil, name: String, maxScore: Double? = nil, passingScore: Double? = nil) {
        self.id = id
        self.name = name
        self.maxScore = maxScore
        self.passingScore = passingScore
    }
}

class ExamResult: Codable {
    @DocumentID var id: String?
    var studentId: String
    var score: Double?
    var comment: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String? = nil, studentId: String, score: Double? = nil, comment: String? = "") {
        self.id = id
        self.studentId = studentId
        self.score = score
        self.comment = comment
    }
}
