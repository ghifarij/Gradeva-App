//
//  NavManager.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation

enum NavPath: String {
    case home
    case settings
}

class NavManager: ObservableObject {
    @Published var paths: [NavPath] = []
    
    // Push
    func push(_ path: NavPath) {
        paths.append(path)
    }
    
    // Back to home
    func reset() {
        paths.removeAll()
    }
    
    // Back
    func back() {
        guard !paths.isEmpty else { return }
        paths.removeLast()
    }
    
    // Replace all items
    func replace(_ path: NavPath) {
        self.reset()
        self.push(path)
    }
}
