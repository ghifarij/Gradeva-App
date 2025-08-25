//
//  SuccessToastView.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import SwiftUI

struct SuccessToastView: View {
    @Binding var showSaveToast: Bool
    
    var body: some View {
        if showSaveToast {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.white)
                    Text("Changes saved")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.green.opacity(0.9))
                .cornerRadius(14)
                .padding(.bottom, 90)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Changes saved successfully")
        }
    }
}