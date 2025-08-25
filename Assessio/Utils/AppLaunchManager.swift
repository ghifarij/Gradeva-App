//
//  AppLaunchManager.swift
//  Assessio
//
//  Created by Claude on 20/08/25.
//

import Foundation
import SwiftUI

class AppLaunchManager: ObservableObject {
    @Published var isFirstLaunch: Bool
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "hasLaunchedBefore"
    
    static let shared = AppLaunchManager()
    
    init() {
        let hasLaunchedBefore = userDefaults.bool(forKey: firstLaunchKey)
        self.isFirstLaunch = !hasLaunchedBefore
    }
    
    func markAppAsLaunched() {
        userDefaults.set(true, forKey: firstLaunchKey)
        
        withAnimation {
            isFirstLaunch = false
        }
    }
}
