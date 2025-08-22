//
//  BatchInfoView.swift
//  Gradeva
//
//  Created by Ramdan on 22/08/25.
//

import SwiftUI

struct BatchInfoView: View {
    @ObservedObject private var batchManager = BatchManager.shared
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "graduationcap.fill")
                
                Text("BATCH")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .fontWeight(.medium)
                
                Text(batchManager.currentBatch?.name ?? "-")
                    .fontWeight(.bold)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Current active batch")
            .accessibilityValue("Batch \(batchManager.currentBatch?.name ?? "unknown")")
            .accessibilityAddTraits(.isStaticText)
            
            Spacer()
            
            Rectangle()
                .fill(.white.opacity(0.3))
                .frame(width: 1)
                .padding(.vertical)
                .accessibilityHidden(true)
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "person.3.fill")
                
                Text("STUDENTS")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .fontWeight(.medium)
                
                Text("\(batchManager.studentCount)")
                    .fontWeight(.bold)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Total students in active batch")
            .accessibilityValue("\(batchManager.studentCount) students")
            .accessibilityAddTraits(.isStaticText)
            
            Spacer()
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(Color.appPrimary)
        .frame(height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    BatchInfoView()
}