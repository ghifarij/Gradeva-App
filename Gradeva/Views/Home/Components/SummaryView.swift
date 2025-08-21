//
//  SummaryView.swift
//  Gradeva
//
//  Created by Ramdan on 21/08/25.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.title2.bold())
                .foregroundStyle(.white)
            
            VStack(spacing: 32) {
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(lineWidth: 12)
                        .foregroundColor(.white)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0.0, to: CGFloat(0.4))
                        .stroke(
                            Color.accentColor,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round)
                        )
                        .rotationEffect(.degrees(-90))
                    
                    // Text in center
                    VStack {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("24")
                                .font(.title.bold())
                            Text("/")
                                .font(.headline)
                            Text("30")
                                .font(.headline)
                        }
                        Text("Graded")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 150, height: 150)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("28")
                                .font(.title.bold())
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                        }
                        Text("Passed")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("2")
                                .font(.title.bold())
                            Spacer()
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.title)
                        }
                        Text("Need assistance")
                            .font(.headline)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SummaryView()
}
