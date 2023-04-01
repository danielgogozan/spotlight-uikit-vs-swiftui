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
    @State var showFilter: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    PillFilterView(selected: $viewModel.selectedTags,
                                   filterItems: viewModel.tags,
                                   multipleSelection: false) {
                        guard let selection = viewModel.selectedTags.first,
                              selection == NewsCategory.filter.rawValue.capitalized else { return }
                        showFilter = true
                    }
                                   .padding([.top], 20)
                    
                    StatefulView(contentView: contentView, viewModel: viewModel)
                }
            }
        }
        .withSearchBar(searchBar) {
            presentationMode.wrappedValue.dismiss()
        }
        .sheet(isPresented: $showFilter) {
            FilterView()
                .presentationDetents([.fraction(0.47)])
        }
    }
    
    var contentView: some View {
        LazyVStack(alignment: .leading) {
            header
                .padding([.top], 10)
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
    
    var searchBar: SearchBarView {
        SearchBarView(searchKey: .constant(viewModel.filterData.query),
                      image: Asset.Images.close.image) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(viewModel: SearchResultsViewModel(apiService: .preview, filterData: FilterData(query: "", selectedCategory: .filter)))
    }
}
