//
//  SearchResultsView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 30.03.2023.
//

import SwiftUI

struct SearchResultsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SearchResultsViewModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                VStack {
                    PillFilterView(selected: .constant(["Filter"]), filterItems: NewsCategory.allCases.map { $0.rawValue.capitalized })
                    StatefulView(contentView: contentView, viewModel: viewModel)
                }
                .toolbar {
                    HStack {
                        SearchBarView(image: Asset.Images.close.image)
                            .frame(width: 300)
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .padding([.leading], -(geometry.size.width - 320) / 2)
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
    }
    
    var contentView: some View {
        VStack {
            Text("Hello results")
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(viewModel: SearchResultsViewModel())
    }
}
