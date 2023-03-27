//
//  HeadlinesView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct HeadlinesView: View {
    @ObservedObject var viewModel: HeadlineViewModel
    var headlines: [Article] = [Article(author: "Auth2", title: "Title1", description: "Desc1"),
                                Article(author: "Auth3", title: "Title1", description: "Desc1"),
                                Article(author: "Auth4", title: "Title1", description: "Desc1"),
                                Article(author: "Auth5", title: "Title1", description: "Desc1"),
                                Article(author: "Auth6", title: "Title1", description: "Desc1"),
                                Article(author: "Auth7", title: "Title1", description: "Desc1"),
                                Article(author: "Auth8", title: "Title1", description: "Desc1"),
                                Article(author: "Auth9", title: "Title1", description: "Desc1")]
    var availableSize: CGSize
    
    var body: some View {
        StatefulView(contentView: contentView, viewModel: viewModel)
            .onAppear { viewModel.getTopHeadlines() }
            .frame(width: availableSize.width,
                   height: availableSize.height * 0.3)
    }
    
    var contentView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.state.payload ?? [], id: \.title) { headline in
                    NavigationLink {
                        ArticleDetailsView(article: headline)
                    } label: {
                        HeadlineView(headline: headline)
                            .frame(width: availableSize.width * 0.9,
                                   height: availableSize.height * 0.3)
                    }
                }
            }
            .padding([.leading, .trailing], 10)
        }
    }
}

struct HeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinesView(viewModel: .preview, availableSize: CGSize(width: 300, height: 500))
    }
}
