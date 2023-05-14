//
//  ArticlesView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct ArticlesListView: View {
    @State private var isPresentingLatest = false
    @ObservedObject var articlesViewModel: ArticleViewModel
    let headlinesViewModel: HeadlineViewModel
    
    var availableSize: CGSize
    @State var selection: Int?
    
    // Note: - ScrollView > ScrollView > InfiniteScrolling with onAppear => X - will not work
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                header
                HeadlinesView(viewModel: headlinesViewModel,
                              availableSize: availableSize)
                
                PillFilterView(selected: $articlesViewModel.selectedTags,
                               filterItems: NewsCategory.homeCases.map { $0.rawValue },
                               multipleSelection: true)
                StatefulView(contentView: contentView, viewModel: articlesViewModel)
            }
        }
    }
    
    var contentView: some View {
        LazyVStack {
            ForEach(articlesViewModel.state.payload ?? [], id: \.id) { article in
                NavigationLink {
                    ArticleDetailsView(article: article)
                } label: {
                    ArticleView(article: article)
                        .onAppear {
                            articlesViewModel.getMore(article)
                        }
                }
            }
            .padding([.leading, .trailing], 10)
            
            if articlesViewModel.showLoadingView {
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
            
            Button {
                isPresentingLatest.toggle()
            } label: {
                HStack(spacing: 20) {
                    Text(L10n.seeAll)
                        .font(FontFamily.Nunito.regular.font(size: 16).swiftUI)
                        .foregroundColor(Asset.Colors.secondary.color.swiftUI)
                    Image(uiImage: Asset.Images.rightArrow.image)
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundColor(Asset.Colors.secondary.color.swiftUI)
                }
            }
            .navigationTitle("")
            .navigationDestination(isPresented: $isPresentingLatest) {
                LatestNewsView(viewModel: headlinesViewModel.latestNewsViewModel)
            }
        }
        .padding([.top], 30)
        .padding([.leading, .trailing], 15)
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesListView(articlesViewModel: .preview,
                     headlinesViewModel: .preview,
                     availableSize: CGSize(width: 600, height: 128))
    }
}
