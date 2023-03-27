//
//  View+Ext.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 11.03.2023.
//

import SwiftUI

extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: width)
        )
    }
}
