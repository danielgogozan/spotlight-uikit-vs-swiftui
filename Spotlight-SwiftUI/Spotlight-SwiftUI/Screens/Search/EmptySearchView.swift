//
//  EmptySearchView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 09.04.2023.
//

import SwiftUI

struct EmptySearchView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: Asset.Images.noDataFound.image)
            Text("Oops.. no data found for your search")
                .font(FontFamily.Nunito.semiBold.font(size: 18).swiftUI)
                .foregroundColor(Asset.Colors.black.color.swiftUI)
        }
    }
}

struct EmptySearchView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchView()
    }
}
