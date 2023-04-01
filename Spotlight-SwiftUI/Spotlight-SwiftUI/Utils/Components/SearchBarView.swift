//
//  SearchBarView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 29.03.2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchKey: String
    var autoFocus: Bool = false
    var image = Asset.Images.iconSearch.image
    var onSearchTapped: (() -> Void)?
    
    @FocusState private var forceFocus: Bool
    
    var body: some View {
        HStack {
            STextField(text: searchKey,
                       error: .constant(""),
                       image: image,
                       placeholder: "Search news",
                       imageColor: Asset.Colors.black.color,
                       height: 10) { text in
                searchKey = text
            } onImageTap: {
                onSearchTapped?()
            }
            .focused($forceFocus)
        }
        .onAppear {
            guard autoFocus else { return }
            forceFocus = true
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchKey: .constant(""))
    }
}
