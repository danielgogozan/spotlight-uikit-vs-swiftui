//
//  HeadlinesView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct HeadlinesView: View {
    @ObservedObject var viewModel: HeadlineViewModel
    @State var selection: Int?
    @State private var selectedHeadline: Article = .init()
    var availableSize: CGSize
    
    var body: some View {
        VStack {
            StatefulView(contentView: contentView, viewModel: viewModel)
                .onAppear { viewModel.getTopHeadlines() }
                .frame(width: availableSize.width, height: availableSize.height * 0.35)
        }
    }
    
    var contentView: some View {
        ZStack {
            NavigationLink(destination: ArticleDetailsView(article: selectedHeadline),
                           tag: 1,
                           selection: $selection) { }
            
            CarouselView(UIState: .init(activeCardId: ""), articles: viewModel.state.payload ?? [], availableSize: availableSize) { article in
                selectedHeadline = article
                selection = 1
            }
        }
    }
}

struct HeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinesView(viewModel: .preview, availableSize: CGSize(width: 300, height: 500))
    }
}
