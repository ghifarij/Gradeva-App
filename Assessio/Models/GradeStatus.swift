//
//  GradeStatus.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import Foundation

enum GradeStatus: String, CaseIterable {
    case all = "All"
    case passed = "Passed"
    case failed = "Not Passed"
    case notGraded = "Not Graded"
}
