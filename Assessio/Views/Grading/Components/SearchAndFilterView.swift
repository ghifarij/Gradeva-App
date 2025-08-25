//
//  SearchAndFilterView.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import SwiftUI

struct SearchAndFilterView: View {
    @Binding var searchText: String
    @Binding var selectedStatus: GradeStatus
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private var isTextLarge: Bool {
        dynamicTypeSize > .xxLarge
    }
    
    var body: some View {
        DynamicHStack(spacing: 16) {
            // SEARCH BAR
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.appPrimary)
                    .accessibilityHidden(true)
                TextField("Search Student", text: $searchText)
                    .foregroundColor(.appPrimary)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .accessibilityLabel("Search students")
                    .accessibilityHint("Type to filter students by name")
            }
            .padding()
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
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.appPrimary)
                }
                .padding()
                .if(isTextLarge) {
                    $0.frame(maxWidth: .infinity)
                }
                .if(!isTextLarge) {
                    $0.frame(minWidth: 120)
                }
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
    }
}
