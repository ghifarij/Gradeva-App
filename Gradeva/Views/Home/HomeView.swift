//
//  HomeView.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import SwiftUI

struct HomeView: View {
    // State for the selected batch in the picker.
    @State private var selectedBatch = "Batch 1"
    private let batches = ["Batch 1", "Batch 2", "Batch 3"]
    
    private let name = "Shinta"
    private let subject = "Hospitality"
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Dropdown menu for selecting a batch.
                    Picker("Select your batch", selection: $selectedBatch) {
                        ForEach(batches, id: \.self) { batch in
                            Text(batch)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    
                    // Horizontal stack for the info cards.
                    HStack(spacing: 16) {
                        InfoCardView(title: "Students", count: 26)
                        InfoCardView(title: "Teachers", count: 7)
                    }
                }
                .padding()
            }
            .navigationTitle("Hello \(name)")
        }
    }
}

#Preview {
    HomeView()
}
