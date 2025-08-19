//
//  ErrorAlertView.swift
//  Gradeva
//
//  Created by Claude Code on 18/08/25.
//

import SwiftUI

struct ErrorAlertView: ViewModifier {
    @Binding var showingError: Bool
    let error: AuthError?
    
    init(showingError: Binding<Bool>, error: AuthError?) {
        self._showingError = showingError
        self.error = error
    }
    
    func body(content: Content) -> some View {
        content
            .alert("Authentication Error", isPresented: $showingError) {
                Button("OK") {
                    showingError = false
                }
            } message: {
                VStack(alignment: .leading, spacing: 8) {
                    if let error = error {
                        Text(error.localizedDescription)
                        
                        if let recoveryMessage = error.recoveryMessage {
                            Text(recoveryMessage)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
    }
}

extension View {
    func authErrorAlert(
        showingError: Binding<Bool>,
        error: AuthError?
    ) -> some View {
        modifier(ErrorAlertView(showingError: showingError, error: error))
    }
}

struct InlineErrorView: View {
    let error: AuthError
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Error")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                
                Text(error.localizedDescription)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let recoveryMessage = error.recoveryMessage {
                    Text(recoveryMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .padding()
        .background(Color.red.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
}
