//
//  ConditionalModifier.swift
//  Gradeva
//
//  Created by Ramdan on 23/08/25.
//

import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
