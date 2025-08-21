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
    case failed = "Need Assist"
    case notGraded = "Not Graded"
}

// A dedicated view for editing the comment, presented as a full screen overlay.
struct CommentOverlayView: View {
    @Binding var comment: String
    @Binding var isShowing: Bool
    let studentName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background covering entire screen
            Color.appPrimary.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    onCancel()
                }
            
            // Comment modal
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Comments for \(studentName)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Text field
                    TextField("Leave a note or feedback (optional)", text: $comment, axis: .vertical)
                        .lineLimit(4...)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // Buttons
                HStack(spacing: 16) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonSecondary)
                    .foregroundColor(.primary)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                    
                    Button("Save") {
                        onSave()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}

struct StudentGradingListView: View {
    let examId: String
    @State private var searchText = ""
    @State private var selectedStatus: GradeStatus = .all
    @State private var showingCommentFor: StudentGrade?
    @FocusState private var focusedStudentID: UUID?
    
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
            ZStack {
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
                                .accessibilityLabel("Search students")
                                .accessibilityHint("Type to filter students by name")
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
                        .accessibilityLabel("Filter by status")
                        .accessibilityValue(selectedStatus.rawValue)
                        .accessibilityHint("Double tap to choose a status filter")
                        .accessibilityAddTraits(.isButton)
                    }
                    .padding()
                    
                    
                    // MARK: Student List
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(filteredStudents) { student in
                                StudentCardView(
                                    student: student,
                                    onCommentTap: {
                                        showingCommentFor = student
                                    },
                                    focusedStudent: $focusedStudentID
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Students Grade")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.appBackground)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        if focusedStudentID != nil {        // ← show only for numeric score fields
                            Spacer()
                            Button("Done") { focusedStudentID = nil }
                        }
                    }
                }
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Students grading screen")
                
                // Global comment overlay
                if let student = showingCommentFor {
                    CommentOverlayView(
                        comment: Binding(
                            get: { student.comment },
                            set: { student.comment = $0 }
                        ),
                        isShowing: Binding(
                            get: { showingCommentFor != nil },
                            set: { _ in }
                        ),
                        studentName: student.name,
                        onSave: {
                            showingCommentFor = nil
                        },
                        onCancel: {
                            showingCommentFor = nil
                        }
                    )
                }
            }
        }
    }
}


#Preview {
    StudentGradingListView(examId: "some_ID")
}
