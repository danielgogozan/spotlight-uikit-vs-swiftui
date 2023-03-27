//
//  HomeView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI

struct HomeView: View {
    let apiService: NewsServiceProtocol
    var headlines: [Article] = [Article(author: "Auth2", title: "Title1", description: "Desc1"),
                                Article(author: "Auth3", title: "Title1", description: "Desc1"),
                                Article(author: "Auth4", title: "Title1", description: "Desc1"),
                                Article(author: "Auth5", title: "Title1", description: "Desc1"),
                                Article(author: "Auth6", title: "Title1", description: "Desc1"),
                                Article(author: "Auth7", title: "Title1", description: "Desc1"),
                                Article(author: "Auth8", title: "Title1", description: "Desc1"),
                                Article(author: "Auth9", title: "Title1", description: "Desc1")]
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    VStack(alignment: .leading) {
                        ArticlesView(viewModel: ArticleViewModel(apiService: apiService),
                                     availableSize: geometry.size)
                        Spacer()
                    }
                    .padding([.top], 0.1) // IMPORTANT: - Force to respect top safe area
                }
            }
        }
    }
}
    
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(apiService: .preview)
    }
}
