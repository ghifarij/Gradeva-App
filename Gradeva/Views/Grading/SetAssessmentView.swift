//
//  SetAssessmentView.swift
//  Gradeva
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

struct SetAssessmentView: View {
    @State private var assessmentName = ""
    @State private var maxScore = ""
    @State private var passingScore = ""
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Assessment Name Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Assessment Name*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Type here", text: $assessmentName)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Assessment name")
                .accessibilityValue(assessmentName.isEmpty ? "Empty" : assessmentName)
                .accessibilityHint("Enter the assessment name")
                
                // Max Score Field
                VStack(alignment: .leading) {
                    Text("Max Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Max Score (e.g., 100)", text: $maxScore)
                        .keyboardType(.numberPad)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Maximum score")
                .accessibilityValue(maxScore.isEmpty ? "Empty" : maxScore)
                .accessibilityHint("Enter the maximum possible score")
                
                // Passing Score Field
                VStack(alignment: .leading) {
                    Text("Passing Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Passing Score (e.g., 75)", text: $passingScore)
                        .keyboardType(.numberPad)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                }
                .padding(.bottom)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Passing score")
                .accessibilityValue(passingScore.isEmpty ? "Empty" : passingScore)
                .accessibilityHint("Enter the minimum score required to pass")

                // Action Buttons
                HStack(spacing: 16) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonSecondary)
                    .foregroundColor(.primary)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Double tap to close without saving")
                    .accessibilityAddTraits(.isButton)
                    
                    Button("Save") {
                        if !assessmentName.isEmpty {
                            onSave(assessmentName)
                            dismiss()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                    .accessibilityLabel("Save assessment")
                    .accessibilityHint("Double tap to save the assessment")
                    .accessibilityValue(assessmentName.isEmpty ? "Disabled until name is entered" : "Enabled")
                    .accessibilityAddTraits(.isButton)
                }
                
                Spacer()
            }
            .padding()
            
            .navigationTitle("Set Assessment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SetAssessmentView(onSave: { newName in
        print("Saved: \(newName)")
    })
}
