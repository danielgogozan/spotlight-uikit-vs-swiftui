//
//  SearchBarView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 29.03.2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchKey: String
    var image = Asset.Images.iconSearch.image
    var onSearchTapped: (() -> Void)?
    
    var body: some View {
        HStack {
            STextField(
                       error: .constant(""),
                       image: image,
                       placeholder: "Search news",
                       didEndEditing: { text in
                           searchKey = text
                       },
                       imageColor: Asset.Colors.black.color,
                       height: 10) {
                           onSearchTapped?()
                       }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchKey: .constant(""))
    }
}
