//
//  LatestNewsView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 27.03.2023.
//

import SwiftUI

struct LatestNewsView: View {
    @EnvironmentObject var tabSettings: TabSettings
    @ObservedObject var viewModel: LatestNewsViewModel
    @State private var isExpanded: Bool = false
    
    var body: some View {
        StatefulView(contentView: contentView, viewModel: viewModel)
            .onAppear {
                tabSettings.show = false
            }
            .onDisappear {
                tabSettings.show = true
            }
    }
    
    var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                    ForEach(viewModel.state.payload ?? [], id: \.id) { article in
                        LatestView(article: article)
                            .onAppear {
                                viewModel.getMore(article)
                            }
                    }
                    .padding([.leading, .trailing], 10)
                    
                    if viewModel.showLoadingView {
                        ProgressView()
                            .tint(Asset.Colors.redish.color.swiftUI)
                    }
            }
        }
    }
}

struct LatestNewsView_Previews: PreviewProvider {
    static var previews: some View {
        LatestNewsView(viewModel: .preview)
    }
}
