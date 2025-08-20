//
//  GradingExamView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct ExamListView: View {
    let subjectId: String
    @State private var isShowingSetAssessment = false
    
    @State private var examTypes = [
        "Theory",
        "Practical",
        "Interview",
        "Final Exam"
    ]
    
    // TODO: In a real app, you would use this subjectId to fetch the subject name
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(examTypes, id: \.self) { examType in
                    ExamCard(title: examType)
                }
            }
            .padding()
        }
        .navigationTitle("Exam")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Set the state to true to show the sheet
                    isShowingSetAssessment = true
                }) {
                    Image(systemName: "pencil.line")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .sheet(isPresented: $isShowingSetAssessment) {
            // Present the SetAssessmentView sheet
            SetAssessmentView { newAssessmentName in
                examTypes.append(newAssessmentName)
            }
            .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    NavigationView {
        ExamListView(subjectId: "some_ID")
    }
}
