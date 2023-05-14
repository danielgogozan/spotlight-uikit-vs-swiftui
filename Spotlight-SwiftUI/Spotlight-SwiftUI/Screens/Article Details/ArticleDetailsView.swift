//
//  ArticleDetailsView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 26.03.2023.
//

import SwiftUI
import Kingfisher

struct ArticleDetailsView: View {
    @EnvironmentObject var tabSettings: TabSettings
    @Environment(\.presentationMode) var presentationMode
    
    @State private var titleViewSize: CGSize = .zero
    let article: Article
    
    var imageUrl: URL? {
        URL(string: article.imageUrl ?? "https://i0.wp.com/www.sudanspost.com/wp-content/uploads/2021/02/BREAKING.png")
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    ZStack {
                        VStack(alignment: .leading) {
                            KFImage(imageUrl)
                                .placeholder {
                                    Image(uiImage: Asset.Images.breakingNews.image)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .frame(height: geometry.size.height / 2)
                            
                            VStack(alignment: .leading) {
                                Text(article.longDescription)
                                    .padding()
                                    .foregroundColor(Asset.Colors.black.color.swiftUI)
                                    .font(FontFamily.Nunito.semiBold.font(size: 14).swiftUI)
                            }
                            .frame(width: geometry.size.width)
                            .padding([.top], titleViewSize.height / 2)
                            .background(Color.white)
                            .cornerRadius(30)
                            .offset(CGSize(width: 0, height: -titleViewSize.height / 2))
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(articleDate)
                                    .font(FontFamily.Nunito.semiBold.font(size: 12).swiftUI)
                                Text(article.title)
                                    .font(FontFamily.NewYorkSmall.heavy.font(size: 16).swiftUI)
                                Text(article.author ?? "")
                                    .font(FontFamily.Nunito.extraBold.font(size: 10).swiftUI)
                            }
                            .padding()
                            Spacer()
                        }
                        .modifier(SizeReaderModifier())
                        .onPreferenceChange(SizePreferenceKey.self, perform: { self.titleViewSize = $0 })
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                        .foregroundColor(Asset.Colors.black.color.swiftUI)
                        .cornerRadius(12)
                        .frame(width: geometry.size.width / 1.25)
                        .position(x: geometry.size.width / 2,
                                  y: geometry.size.height / 2 - titleViewSize.height / 2)
                    }
                }
            }
            backButton
        }
        .onAppear {
            guard tabSettings.show else { return }
            tabSettings.show = false
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    var backButton: some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(uiImage: Asset.Images.backArrow.image)
                        .resizable()
                        .foregroundColor(Asset.Colors.black.color.swiftUI)
                        .padding([.leading, .trailing], 5)
                        .frame(width: 30, height: 30)
                        .background(
                            .ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                        )
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding([.top], 50)
    }
    
    var articleDate: String {
        guard let publishedAt = article.publishedAt,
              let date = DateUtils.defaultDateFormatter().date(from: publishedAt) else { return "13.03.2023" }
        return DateUtils.prettyArticleDate(for: date)
    }
}

struct ArticleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailsView(article: Article(author: "Some author", title: "Very Interesting title ", description: "Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description. Some really long description."))
    }
}
