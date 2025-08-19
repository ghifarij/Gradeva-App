//
//  SubjectSelection.swift
//  Gradeva
//
//  Created by Ramdan on 19/08/25.
//

import SwiftUI

struct SubjectSelection: View {
    let subject: Subject
    @Binding var selectedSubjects: Set<String>
    
    private var isSelected: Bool {
        guard let subjectId = subject.id else { return false }
        selectedSubjects.contains(subjectId)
    }
    
    private func toggleSelection() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            guard let subjectId = subject.id else { return }
            if isSelected {
                selectedSubjects.remove(subjectId)
            } else {
                selectedSubjects.insert(subjectId)
            }
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Text(subject.name)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(isSelected ? .primary : .secondary)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.secondary.opacity(0.5), lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
                    )
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.accentColor.opacity(0.05) : Color(.systemGray6))
                .stroke(isSelected ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(subject.name)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select") this subject")
        .onTapGesture(perform: toggleSelection)
    }
}

#Preview {
    SubjectSelection(
        subject: Subject(id: "1", name: "Matematika"),
        selectedSubjects: .constant(Set<String>(arrayLiteral: "1"))
    )
}
