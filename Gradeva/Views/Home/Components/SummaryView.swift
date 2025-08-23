//
//  SummaryView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject private var subjectsManager = SubjectsManager.shared
    @ObservedObject private var batchManager = BatchManager.shared
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    private var isTextLarge: Bool {
        dynamicTypeSize > .xxLarge
    }
    
    private var pendingReview: Int {
        subjectsManager.selectedSubject?.pendingReview ?? 0
    }
    
    private var totalStudents: Int {
        batchManager.studentCount
    }
    
    private var progress: Double {
        if totalStudents == 0 {
            return 1
        } else {
            return Double((totalStudents - pendingReview) / totalStudents)
        }
    }
    
    private var studentsPassed: Int {
        subjectsManager.selectedSubject?.totalStudentsPassed ?? 0
    }
    
    private var studentsFailed: Int {
        subjectsManager.selectedSubject?.totalStudentsFailed ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.title2.bold())
                .foregroundStyle(.white)
                .accessibilityAddTraits(.isHeader)
            
            VStack(spacing: 32) {
                ZStack {
                    if !isTextLarge {
                        ZStack {
                            // Background circle
                            Circle()
                                .stroke(lineWidth: 12)
                                .foregroundColor(.white)
                                .accessibilityHidden(true)
                            
                            // Progress circle
                            Circle()
                                .trim(from: 0.0, to: CGFloat(progress))
                                .stroke(
                                    Color.appPrimaryDarker,
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round)
                                )
                                .rotationEffect(.degrees(-90))
                                .accessibilityHidden(true)
                        }
                        .frame(width: 150, height: 150)
                    }
                    
                    // Text in center
                    VStack {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text((totalStudents - pendingReview).description)
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Text("/")
                                .font(.headline)
                                .accessibilityHidden(true)
                            Text(totalStudents.description)
                                .font(.headline)
                                .accessibilityHidden(true)
                        }
                        Text("Graded")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .combine)
                
                DynamicHStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(studentsPassed.description)
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .accessibilityHidden(true)
                        }
                        Spacer()
                        Text("Passed")
                            .font(.headline)
                            .fontWeight(.medium)
                            .accessibilityHidden(true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(.appSuccess)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isStaticText)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text(studentsFailed.description)
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.title)
                                .accessibilityHidden(true)
                        }
                        Spacer()
                        Text("Need assistance")
                            .font(.headline)
                            .fontWeight(.medium)
                            .accessibilityHidden(true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                    .background(.appDestructive)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isStaticText)
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .accessibilityElement(children: .combine)
            .accessibilityValue("\(totalStudents - pendingReview) out of \(totalStudents) assignments graded. \(studentsPassed) students passed, \(studentsFailed) students need assistance.")
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SummaryView()
}
