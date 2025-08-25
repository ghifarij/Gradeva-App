//
//  CommentOverlayView.swift
//  Gradeva
//
//  Extracted from StudentGradingListView on 25/08/25.
//

import SwiftUI

// A dedicated view for editing the comment, presented as a full screen overlay.
struct CommentOverlayView: View {
    @Binding var comment: String
    @Binding var isShowing: Bool
    let studentName: String
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background covering entire screen
            Color.appPrimary.opacity(0.4)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    onCancel()
                }
            
            // Comment modal
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Comments for \(studentName)")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                        .multilineTextAlignment(.center)
                    
                    // Text field
                    TextField("Leave a note or feedback (optional)", text: $comment, axis: .vertical)
                        .lineLimit(4...)
                        .padding()
                        .foregroundColor(.textPrimary)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(10)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // Buttons
                HStack(spacing: 16) {
                    Button("Cancel") {
                        onCancel()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonSecondary)
                    .foregroundColor(.primary)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                    
                    Button("Save") {
                        onSave()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.buttonPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        }
        .animation(.easeInOut(duration: 0.3), value: isShowing)
    }
}

