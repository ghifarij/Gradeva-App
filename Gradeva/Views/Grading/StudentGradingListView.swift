//
//  GradingStudentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

enum GradeStatus: String, CaseIterable {
    case all = "All"
    case passed = "Passed"
    case failed = "Need Assistance"
    case notGraded = "Not Graded"
}

struct StudentGradingListView: View {
    let examId: String
    @State private var searchText = ""
    @State private var selectedStatus: GradeStatus = .all
    
    @State private var students: [StudentGrade] = [
        StudentGrade(name: "Putri Tanjung", score: nil),
        StudentGrade(name: "Ahmad Dhani", score: 80),
        StudentGrade(name: "Bunga Citra", score: 65),
        StudentGrade(name: "Rizky Febian", score: 95),
        StudentGrade(name: "Isyana Sarasvati", score: 88)
    ]
    
    private let passingGrade = 80
    
    private var filteredStudents: [StudentGrade] {
        var students = students
        
        // Apply search filter
        if !searchText.isEmpty {
            students = students.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        // Apply status filter
        switch selectedStatus {
        case .passed:
            students = students.filter { $0.score != nil && $0.score! >= passingGrade }
        case .failed:
            students = students.filter { $0.score != nil && $0.score! < passingGrade }
        case .notGraded:
            students = students.filter { $0.score == nil }
        case .all:
            break // No status filter needed
        }
        
        return students
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                // MARK: Search and Filter UI
                HStack(spacing: 16) {
                    // SEARCH BAR
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.appPrimary)
                        TextField("Search Student", text: $searchText)
                            .foregroundColor(.appPrimary)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appPrimary, lineWidth: 1)
                    )
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity)

                    // DROPDOWN
                    Menu {
                        Picker("All Statuses", selection: $selectedStatus) {
                            ForEach(GradeStatus.allCases, id: \.self) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .pickerStyle(.inline)
                    } label: {
                        HStack {
                            Text(selectedStatus.rawValue)
                                .foregroundColor(.appPrimary)
                            Image(systemName: "chevron.down")
                                .foregroundColor(.appPrimary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.appPrimary, lineWidth: 1)
                        )
                        .cornerRadius(12)
                    }
                }
                .padding()

                
                // MARK: Student List
                ScrollView {
                    VStack(spacing: 12) {
                        // The ForEach loop now iterates over the filteredStudents array.
                        ForEach(filteredStudents) { student in
                            StudentCardView(student: student)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Students Grade")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.appBackground)
        }
    }
}


#Preview {
    StudentGradingListView(examId: "some_ID")
}
