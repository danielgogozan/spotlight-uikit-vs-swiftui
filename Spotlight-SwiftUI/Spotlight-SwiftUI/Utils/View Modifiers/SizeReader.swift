//
//  SizeReader.swift
//  Boovie
//
//  Created by Daniel Gogozan on 12.01.2023.
//  Copyright © 2023 Softvision. All rights reserved.
//

import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

/// Use this to attach a GeometryReader to the background of a view getting access to the real content size of it by implementing .onPreferenceChange for SizePreferenceKey
struct SizeReaderModifier: ViewModifier {
    private var sizeReaderView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(sizeReaderView)
    }
}
