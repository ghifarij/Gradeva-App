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
        DynamicHStack {
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
            
            Spacer()
            
            Divider()
                .background(.white)
                        
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
            Spacer()
        }
        .padding()
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .background(Color.appPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel("Current active batch: \(batchManager.currentBatch?.name ?? "none"), with \(batchManager.studentCount) students in total")
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    BatchInfoView()
}
