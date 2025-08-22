//
//  DynamicHStack.swift
//  Gradeva
//
//  Created by Claude Code on 22/08/25.
//

import SwiftUI

struct DynamicHStack<Content: View>: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    private let hAlignment: VerticalAlignment
    private let vAlignment: HorizontalAlignment
    private let spacing: CGFloat?
    private let content: () -> Content
    
    init(
        alignment: VerticalAlignment = .center,
        vAlignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.hAlignment = alignment
        self.vAlignment = vAlignment
        self.spacing = spacing
        self.content = content
    }
    
    private var shouldUseVStack: Bool {
        dynamicTypeSize > .xxLarge
    }
    
    var body: some View {
        if shouldUseVStack {
            VStack(alignment: vAlignment, spacing: spacing) {
                content()
            }
        } else {
            HStack(alignment: hAlignment, spacing: spacing) {
                content()
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        DynamicHStack {
            Text("First")
                .padding()
                .background(Color.blue.opacity(0.3))
                .cornerRadius(8)
            
            Text("Second")
                .padding()
                .background(Color.green.opacity(0.3))
                .cornerRadius(8)
        }
        
        Text("Switches to VStack when Dynamic Type > .xLarge")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}
