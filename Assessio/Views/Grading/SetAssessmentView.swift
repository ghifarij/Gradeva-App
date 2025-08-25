//
//  SetAssessmentView.swift
//  Assessio
//
//  Created by Afga Ghifari on 19/08/25.
//

import SwiftUI

struct SetAssessmentView: View {
    @State private var assessmentName = ""
    @State private var maxScore = ""
    @State private var passingScore = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field {
        case assessmentName, maxScore, passingScore
    }
    
    @Environment(\.dismiss) var dismiss
    
    var onSave: (String, Double, Double) -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                // Assessment Name Field
                VStack(alignment: .leading) {
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
                        .focused($focusedField, equals: .assessmentName)
                }
                .padding(.bottom)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Assessment name")
                .accessibilityValue(assessmentName.isEmpty ? "Empty" : assessmentName)
                .accessibilityHint("Double tap to input assessment name.")
                
                // Max Score Field
                VStack(alignment: .leading) {
                    Text("Max Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Max Score (e.g., 100)", text: $maxScore)
                        .keyboardType(.decimalPad)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                        .focused($focusedField, equals: .maxScore)
                }
                .padding(.bottom)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Maximum score")
                .accessibilityValue(maxScore.isEmpty ? "Empty" : maxScore)
                .accessibilityHint("Double tap to input maximum score.")
                
                // Passing Score Field
                VStack(alignment: .leading) {
                    Text("Passing Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    TextField("Passing Score (e.g., 75)", text: $passingScore)
                        .keyboardType(.decimalPad)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                        .focused($focusedField, equals: .passingScore)
                }
                .padding(.bottom)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Passing score")
                .accessibilityValue(passingScore.isEmpty ? "Empty" : passingScore)
                .accessibilityHint("Double tap to input the minimum score required to pass")
                
                // Action Buttons
                DynamicHStack(spacing: 16) {
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
                        let trimmedName = assessmentName.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmedName.isEmpty,
                           let max = parseDecimal(maxScore),
                           let pass = parseDecimal(passingScore) {
                            onSave(trimmedName, max, pass)
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
            }
            .padding()
            .navigationTitle("Set Assessment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    if focusedField == .maxScore || focusedField == .passingScore {
                        Button("Done") {
                            focusedField = nil
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SetAssessmentView(onSave: { name, max, pass in
        print("Saved: \\(name) | max: \\(max) | pass: \\(pass)")
    })
}
