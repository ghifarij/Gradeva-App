//
//  AnalyticsView.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import SwiftUI

struct AnalyticsView: View {
    var body: some View {
        Text("Hello, from AnalyticsView!")
            .accessibilityLabel("Analytics screen placeholder")
            .accessibilityHint("This is a placeholder for the analytics screen")
            .accessibilityAddTraits(.isStaticText)
    }
}

#Preview {
    AnalyticsView()
}
