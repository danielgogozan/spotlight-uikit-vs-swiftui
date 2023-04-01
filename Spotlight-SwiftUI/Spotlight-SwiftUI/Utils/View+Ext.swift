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
    
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().tintColor = Asset.Colors.black.color
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
    
    func storeSize(in size: Binding<CGSize>) -> some View {
        modifier(SizeReader(size: size))
    }
    
    func withSearchBar(_ searchBar: SearchBarView, _ onTapGesture: (() -> Void)? = nil) -> some View {
        modifier(SearchBarModifier(searchBar: searchBar, onTapGesture: onTapGesture))
    }
}
