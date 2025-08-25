//
//  SaveButtonView.swift
//  Assessio
//
//  Created by Claude on 25/08/25.
//

import SwiftUI

struct SaveButtonView: View {
    let hasPendingChanges: Bool
    let isKeyboardVisible: Bool
    let onSave: () -> Void
    
    var body: some View {
        if hasPendingChanges && isKeyboardVisible {
            HStack {
                Spacer()
                
                Button("Save") {
                    onSave()
                }
                .padding()
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .background(Color.appPrimary)
                .cornerRadius(50)
                .accessibilityLabel("Save changes")
                .accessibilityHint("Double tap to save changes")
                
                Spacer()
            }
            .padding(.bottom, 8)
            .background(Color.clear)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}
