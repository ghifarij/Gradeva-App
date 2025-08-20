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
