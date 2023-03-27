//
//  ArticleView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI
import Kingfisher

struct ArticleView: View {
    var article: Article
    
    var imageUrl: URL? {
        URL(string: article.imageUrl ?? "https://i0.wp.com/www.sudanspost.com/wp-content/uploads/2021/02/BREAKING.png")
    }
    
    var articleDate: String {
        guard let publishedAt = article.publishedAt,
              let date = DateUtils.defaultDateFormatter().date(from: publishedAt) else { return "13.03.2023" }
        return DateUtils.prettyArticleDate(for: date)
    }
    
    var body: some View {
        VStack {
            KFImage(imageUrl)
                .placeholder {
                    Image(uiImage: Asset.Images.breakingNews.image)
                }
                .resizable()
                .frame(height: 150)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(8)
                .overlay(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        Color(.black.withAlphaComponent(0.5))
                            .cornerRadius(8)
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(FontFamily.NewYorkSmall.semibold.font(size: 16).swiftUI)
                            Spacer()
                            HStack {
                                Text(article.author ?? "")
                                    .font(FontFamily.Nunito.regular.font(size: 12).swiftUI)
                                    .lineLimit(1)
                                Spacer()
                                Text(articleDate)
                                    .font(FontFamily.Nunito.regular.font(size: 12).swiftUI)
                                Button {
                                    print("Favorite")
                                } label: {
                                    Image(uiImage: Asset.Images.favorite.image)
                                }
                            }
                        }
                        .padding(10)
                    }
                }
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(article: Article(author: "author name", title: "some title", description: "headline description"))
    }
}
