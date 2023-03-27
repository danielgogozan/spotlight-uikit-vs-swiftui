//
//  CheckboxToggle.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 11.03.2023.
//

import SwiftUI

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? Asset.Colors.primary.color.swiftUI : Asset.Colors.black.color.swiftUI)
                configuration.label
            }
        })
    }
}
