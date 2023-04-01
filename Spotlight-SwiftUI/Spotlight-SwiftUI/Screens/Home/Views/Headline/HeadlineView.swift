//
//  HeadlineView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 14.03.2023.
//

import SwiftUI
import Kingfisher

struct HeadlineView: View {
    var headline: Article
    
    var imageUrl: URL? {
        URL(string: headline.imageUrl ?? "https://static.vecteezy.com/system/resources/thumbnails/002/530/160/original/news-live-background-4k-free-video.jpg")
    }
    
    var body: some View {
        VStack {
            KFImage(imageUrl)
                .placeholder {
                    Image(uiImage: Asset.Images.breakingNews.image)
                }
                .resizable()
                .overlay(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        Color(.black.withAlphaComponent(0.4))
                            .cornerRadius(10)
                        VStack(alignment: .leading) {
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(headline.author ?? "")
                                    .font(FontFamily.Nunito.extraBold.font(size: 15).swiftUI)
                                Text(headline.title)
                                    .font(FontFamily.NewYorkSmall.semibold.font(size: 20).swiftUI)
                            }
                            Spacer()
                            Text(headline.description ?? "")
                                .font(FontFamily.Nunito.regular.font(size: 15).swiftUI)
                        }
                        .padding(10)
                    }
                }
                .foregroundColor(.white)
        }
        .cornerRadius(10)
    }
}

struct HeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineView(headline: Article(author: "author name", title: "some title", description: "headline description"))
    }
}
