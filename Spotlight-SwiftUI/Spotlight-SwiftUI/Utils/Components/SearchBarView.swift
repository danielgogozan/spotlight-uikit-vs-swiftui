//
//  SearchBarView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 29.03.2023.
//

import SwiftUI

struct SearchBarView: View {
    var image = Asset.Images.iconSearch.image
    
    var body: some View {
        HStack {
            STextField(error: .constant(""),
                       image: image,
                       placeholder: "Search news",
                       imageColor: Asset.Colors.black.color,
                       height: 10)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView()
    }
}
