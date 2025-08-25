//
//  GradingView.swift
//  Assessio
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct GradingView: View {
    @ObservedObject var subjectsManager = SubjectsManager.shared
    @ObservedObject var auth = AuthManager.shared
    
    private var userSubjects: [Subject] {
        if let subjectIds = auth.currentUser?.subjectIds {
            return subjectsManager.subjects.filter { subject in
                if let id = subject.id { return subjectIds.contains(id) }
                else { return false }
            }
        }
        
        return []
    }
    
    private var userSubjectsGrid: [[Subject]] {
        let subjects = userSubjects
        var grid: [[Subject]] = []
        
        for i in stride(from: 0, to: subjects.count, by: 2) {
            let endIndex = min(i + 2, subjects.count)
            grid.append(Array(subjects[i..<endIndex]))
        }
        
        return grid
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(userSubjectsGrid.indices, id: \.self) { rowIndex in
                        DynamicHStack(spacing: 16) {
                            ForEach(userSubjectsGrid[rowIndex], id: \.id) { subject in
                                GradingCard(subject: subject)
                            }
                        }
                    }
                }
                .padding()
                .accessibilityElement(children: .contain)
                .accessibilityLabel("Subject selection screen")
                .accessibilityAddTraits(.isHeader)
            }
            .navigationTitle("Subjects")
        }
    }
}

#Preview {
    GradingView()
}
