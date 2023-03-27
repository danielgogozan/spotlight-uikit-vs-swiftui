//
//  String+.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 26.03.2023.
//

import Foundation

extension String {
    var capitalized: String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
}
