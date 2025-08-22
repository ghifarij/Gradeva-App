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
                .accessibilityAddTraits(.isHeader)
            
            VStack(spacing: 32) {
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(lineWidth: 12)
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0.0, to: CGFloat(0.4))
                        .stroke(
                            Color.appPrimaryDarker,
                            style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .accessibilityHidden(true)
                    
                    // Text in center
                    VStack {
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Text("24")
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Text("/")
                                .font(.headline)
                                .accessibilityHidden(true)
                            Text("30")
                                .font(.headline)
                                .accessibilityHidden(true)
                        }
                        Text("Graded")
                            .font(.headline)
                            .fontWeight(.medium)
                            .opacity(0.7)
                            .accessibilityHidden(true)
                    }
                    .foregroundColor(.white)
                }
                .frame(width: 150, height: 150)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Grading progress: 24 out of 30 assignments graded")
                .accessibilityValue("80 percent complete")
                .accessibilityAddTraits(.isStaticText)
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("28")
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title)
                                .accessibilityHidden(true)
                        }
                        Text("Passed")
                            .font(.headline)
                            .fontWeight(.medium)
                            .accessibilityHidden(true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(.appSuccess)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("28 students passed")
                    .accessibilityAddTraits(.isStaticText)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Text("2")
                                .font(.title.bold())
                                .accessibilityHidden(true)
                            Spacer()
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.title)
                                .accessibilityHidden(true)
                        }
                        Text("Need assistance")
                            .font(.headline)
                            .fontWeight(.medium)
                            .accessibilityHidden(true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background(.appDestructive)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("2 students need assistance")
                    .accessibilityAddTraits(.isStaticText)
                    
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
