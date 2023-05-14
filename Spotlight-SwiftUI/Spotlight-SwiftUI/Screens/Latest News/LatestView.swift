//
//  LatestView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 27.03.2023.
//

import SwiftUI
import Kingfisher

struct LatestView: View {
    var article: Article
    
    var imageUrl: URL? {
        URL(string: article.imageUrl ?? "https://www.manager.ro/dbimg/articole/breakingnews_107768.jpg")
    }
    
    var articleDate: String {
        guard let publishedAt = article.publishedAt,
              let date = DateUtils.prettyDateFormatter().date(from: publishedAt) else { return "Monday, 10 May 2021" }
        return DateUtils.prettyArticleDate(for: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(imageUrl)
                .placeholder {
                    Image(uiImage: Asset.Images.breakingNews.image)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .frame(height: 128)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(articleDate)
                    .font(FontFamily.Nunito.light.font(size: 12).swiftUI)
                
                Text(article.title)
                    .font(FontFamily.NewYorkSmall.semibold.font(size: 14).swiftUI)
                
                ExpandableText(article.longDescription,
                               lineLimit: 3,
                               font: FontFamily.Nunito.regular.font(size: 14))
                .foregroundColor(Asset.Colors.black.color.swiftUI)
                
                Text(L10n.publishedBy(article.author ?? "unkwnown author"))
                    .font(FontFamily.Nunito.bold.font(size: 12).swiftUI)
            }
        }
        .foregroundColor(Asset.Colors.black.color.swiftUI)
    }
}

struct LatestView_Previews: PreviewProvider {
    static var previews: some View {
        LatestView(article: Article(author: "author name", title: "some title", description: "headline description"))
    }
}
