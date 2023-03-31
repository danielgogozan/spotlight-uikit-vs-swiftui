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
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        PillFilterView(selected: $viewModel.selectedTags,
                                       filterItems: viewModel.tags,
                                       multipleSelection: false)
                        StatefulView(contentView: contentView, viewModel: viewModel)
                    }
                }
                .toolbar {
                    HStack {
                        SearchBarView(searchKey: .constant(viewModel.filterData.query),
                                      image: Asset.Images.close.image)
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
        LazyVStack(alignment: .leading) {
            header
                .padding(10)
            ForEach(viewModel.state.payload ?? [], id: \.title) { article in
                NavigationLink {
                    ArticleDetailsView(article: article)
                } label: {
                    ArticleView(article: article)
                        .onAppear {
                            viewModel.getMore(article)
                        }
                }
            }
            .padding([.leading, .trailing], 10)
            
            if viewModel.showLoadingView {
                ProgressView()
                    .tint(Asset.Colors.redish.color.swiftUI)
            }
        }
    }
    
    var header: some View {
        Text("About ")
            .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
            .foregroundColor(Asset.Colors.black.color.swiftUI)
        +
        Text(viewModel.totalResults.description)
            .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
            .foregroundColor(Asset.Colors.primary.color.swiftUI)
        +
        Text(" results for ")
            .font(FontFamily.Nunito.regular.font(size: 14).swiftUI)
            .foregroundColor(Asset.Colors.black.color.swiftUI)
        +
        Text(viewModel.filterData.query)
            .font(FontFamily.Nunito.semiBoldItalic.font(size: 14).swiftUI)
            .foregroundColor(Asset.Colors.black.color.swiftUI)
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(viewModel: SearchResultsViewModel(apiService: .preview, filterData: FilterData(query: "", selectedCategory: .filter)))
    }
}
