//
//  NavUtils.swift
//  Gradeva
//
//  Created by Ramdan on 14/08/25.
//

import Foundation
import SwiftUI

func getNavDestination(_ path: NavPath) -> some View {
    switch path {
    case .settings:
        return SettingsView()
    }
}
