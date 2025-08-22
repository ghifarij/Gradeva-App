//
//  SubjectsSectionView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct SubjectsSectionView: View {
    @ObservedObject private var viewModel = ProfileViewModel.shared
    
    var body: some View {
        Section("Teaching Subjects") {
            if viewModel.userSubjects.isEmpty {
                HStack {
                    Image(systemName: "book.closed")
                        .foregroundColor(.secondary)
                    Text("No subjects assigned")
                        .foregroundColor(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("No subjects assigned")
            } else {
                ForEach(Array(viewModel.userSubjects.enumerated()), id: \.element.id) { index, subject in
                    HStack {
                        Text("\(index + 1).")
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                        Text(subject.name)
                        Spacer()
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Subject \(index + 1)")
                    .accessibilityValue(subject.name)
                }
            }
        }
    }
}

#Preview {
    List {
        SubjectsSectionView()
    }
}