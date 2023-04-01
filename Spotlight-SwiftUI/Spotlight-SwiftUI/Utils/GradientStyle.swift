//
//  GradientModifier.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 01.04.2023.
//

import Foundation
import SwiftUI

struct Gradients {
    static var activeGradient: LinearGradient {
        let gradient = Gradient(colors: [
            Asset.Colors.primary.color.swiftUI.opacity(0.9),
            Asset.Colors.primary.color.swiftUI.opacity(0.65)
        ])
        return LinearGradient(gradient: gradient,
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }
    
    static var inactiveGradient: LinearGradient {
        let gradient = Gradient(colors: [
            Asset.Colors.lightGray.color.swiftUI.opacity(0.9),
            Asset.Colors.lightGray.color.swiftUI.opacity(0.65)
        ])
        return LinearGradient(gradient: gradient,
                              startPoint: .topLeading,
                              endPoint: .bottomTrailing)
    }
}
