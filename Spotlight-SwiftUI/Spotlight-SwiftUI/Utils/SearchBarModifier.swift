//
//  SearchBarModifier.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 01.04.2023.
//

import SwiftUI

struct SearchBarModifier: ViewModifier {
    let searchBar: SearchBarView
    let onTapGesture: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .toolbar {
                            HStack {
                                searchBar
                                    .onTapGesture {
                                        onTapGesture?()
                                    }
                                .frame(width: 300)
                                .padding([.leading], -(geometry.size.width - 320) / 2.75)
                            }
                            .frame(width: geometry.size.width)
                        }
                }
                )
    }
    
}
