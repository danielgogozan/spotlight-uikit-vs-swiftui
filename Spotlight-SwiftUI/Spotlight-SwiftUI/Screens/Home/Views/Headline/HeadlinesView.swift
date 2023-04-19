//
//  HeadlinesView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct HeadlinesView: View {
    @State private var isPresentingDetails = false
    @State private var selectedHeadline: Article = .init()
    
    @ObservedObject var viewModel: HeadlineViewModel
    @State var selection: Int?
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
            CarouselView(UIState: .init(activeCardId: ""), articles: viewModel.state.payload ?? [], availableSize: availableSize) { article in
                selectedHeadline = article
                isPresentingDetails.toggle()
            }
        }
        .navigationDestination(isPresented: $isPresentingDetails) {
            ArticleDetailsView(article: selectedHeadline)
        }
    }
}

struct HeadlinesView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlinesView(viewModel: HeadlineViewModel.preview, availableSize: CGSize(width: 300, height: 500))
    }
}
