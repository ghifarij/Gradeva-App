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
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    var pendingReview: Int?
    var totalStudentsPassed: Int?
    var totalStudentsFailed: Int?
    
    init(id: String? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

class ExamResult: Codable {
    @DocumentID var id: String?
    var studentID: String
    var score: Int
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String? = nil, studentID: String, score: Int) {
        self.id = id
        self.studentID = studentID
        self.score = score
    }
}
