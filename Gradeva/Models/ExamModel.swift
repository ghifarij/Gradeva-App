//
//  ExamModel.swift
//  Gradeva
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
    
    init(id: String? = nil, name: String, maxScore: Double? = nil, passingScore: Double? = nil) {
        self.id = id
        self.name = name
        self.maxScore = maxScore
        self.passingScore = passingScore
    }
}

class ExamResult: Codable {
    @DocumentID var id: String?
    var studentID: String
    var score: Double
    var comment: String?
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String? = nil, studentID: String, score: Double, comment: String? = "") {
        self.id = id
        self.studentID = studentID
        self.score = score
        self.comment = comment
    }
}
