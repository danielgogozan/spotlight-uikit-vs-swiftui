//
//  ArticlesView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct ArticlesView: View {
    @ObservedObject var viewModel: ArticleViewModel
    @State private var headlineViewModel = HeadlineViewModel(apiService: .preview)
    @State var selection: Int?
    
    var headlines: [Article] = [Article(author: "Auth2", title: "Title1", description: "Desc1"),
                                Article(author: "Auth3", title: "Title2", description: "Desc1"),
                                Article(author: "Auth4", title: "Title3", description: "Desc1"),
                                Article(author: "Auth5", title: "Title4", description: "Desc1"),
                                Article(author: "Auth6", title: "Title5", description: "Desc1"),
                                Article(author: "Auth7", title: "Title6", description: "Desc1"),
                                Article(author: "Auth8", title: "Title7", description: "Desc1"),
                                Article(author: "Auth9", title: "Title8", description: "Desc1")]
    var availableSize: CGSize
    
    // Note: - ScrollView > ScrollView > InfiniteScrolling with onAppear => X - will not work
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                header
//                HeadlinesView(viewModel: headlineViewModel,
//                              availableSize: availableSize)
                
                PillFilterView(selected: $viewModel.selectedTags,
                               filterItems: NewsCategory.homeCases.map { $0.rawValue },
                               multipleSelection: true)
//                StatefulView(contentView: contentView, viewModel: viewModel)
            }
        }
    }
    
    var contentView: some View {
        LazyVStack {
            ForEach(viewModel.state.payload ?? [], id: \.id) { article in
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
        HStack {
            Text(L10n.latestNews)
                .font(FontFamily.NewYorkSmall.heavy.font(size: 22).swiftUI)
            Spacer()
            NavigationLink(destination: LatestNewsView(viewModel: LatestNewsViewModel(apiService: .preview, articles: headlineViewModel.state.payload ?? [])),
                           tag: 1,
                           selection: $selection) {
                Button {
                    selection = 1
                } label: {
                    HStack(spacing: 20) {
                        Text(L10n.seeAll)
                            .font(FontFamily.Nunito.regular.font(size: 18).swiftUI)
                            .foregroundColor(Asset.Colors.secondary.color.swiftUI)
                        Image(uiImage: Asset.Images.rightArrow.image)
                            .resizable()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Asset.Colors.secondary.color.swiftUI)
                    }
                }
            }
                           .navigationTitle("")
        }
        .padding([.top], 30)
        .padding([.leading, .trailing], 15)
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesView(viewModel: .preview,
                     availableSize: CGSize(width: 600, height: 128))
    }
}
