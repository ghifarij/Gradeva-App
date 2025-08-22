//
//  NavManager.swift
//  Gradeva
//
//  Created by Ramdan on 13/08/25.
//

import Foundation

enum NavPath: Hashable {
    case settings
    case grading(String)
    case exam(String)
    case profile
}

class NavManager: ObservableObject {
    @Published var paths: [NavPath] = []
    
    static let shared = NavManager()
    
    // Push
    func push(_ path: NavPath) {
        paths.append(path)
    }
    
    func push(_ paths: [NavPath]) {
        self.paths.append(contentsOf: paths)
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
