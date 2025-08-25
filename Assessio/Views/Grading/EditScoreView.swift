//
//  EditScoreView.swift
//  Gradeva
//
//  Created by Codex CLI on 21/08/25.
//

import SwiftUI

struct EditScoreView: View {
    @State private var maxScoreText: String
    @State private var passingScoreText: String

    @FocusState private var focusedField: Field?
    enum Field { case maxScore, passingScore }

    @Environment(\.dismiss) var dismiss

    let onSave: (Double, Double) -> Void

    init(initialMaxScore: Double?, initialPassingScore: Double?, onSave: @escaping (Double, Double) -> Void) {
        self._maxScoreText = State(initialValue: initialMaxScore != nil ? String(initialMaxScore!) : "")
        self._passingScoreText = State(initialValue: initialPassingScore != nil ? String(initialPassingScore!) : "")
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Max Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    TextField("Max Score (e.g., 100)", text: $maxScoreText)
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
                .accessibilityValue(maxScoreText.isEmpty ? "Empty" : maxScoreText)
                .accessibilityHint("Enter the maximum possible score")

                VStack(alignment: .leading) {
                    Text("Passing Score*")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    TextField("Passing Score (e.g., 75)", text: $passingScoreText)
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
                .accessibilityValue(passingScoreText.isEmpty ? "Empty" : passingScoreText)
                .accessibilityHint("Enter the minimum score required to pass")

                HStack(spacing: 16) {
                    Button("Cancel") { dismiss() }
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
                        if let max = parseDecimal(maxScoreText),
                           let pass = parseDecimal(passingScoreText) {
                            onSave(max, pass)
                            dismiss()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                    .accessibilityLabel("Save changes")
                    .accessibilityHint("Double tap to save the new scores")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .padding()
            .navigationTitle("Edit Scores")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    if focusedField == .maxScore || focusedField == .passingScore {
                        Button("Done") { focusedField = nil }
                    }
                }
            }
        }
    }
}

#Preview {
    EditScoreView(initialMaxScore: 100, initialPassingScore: 75) { _, _ in }
}
