//
//  ArticleViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 27.02.2022.
//

import Foundation
import UIKit

class ArticleViewModel: Equatable {
    
    // MARK: - Private properties
    private let article: Article
    private let dateFormatter: DateFormatter
    
    // MARK: - Public properties
    let noSections = 2
    let articleSubject = Observable<Article?>(nil)
    let articleDate = Observable<String>("")
    var currentArticle: Article {
        article
    }
    
    // MARK: - Public API
    init(article: Article, dateFormatter: DateFormatter = DateUtils.defaultDateFormatter()) {
        self.article = article
        self.dateFormatter = dateFormatter
        self.articleSubject.value = article
        setArticleDate()
    }
    
    private func setArticleDate() {
        guard let publishedAt = article.publishedAt,
              let date = dateFormatter.date(from: publishedAt) else { return }
        let prettyDate = DateUtils.prettyArticleDate(for: date)
        articleDate.value = prettyDate
    }
    
    static func == (lhs: ArticleViewModel, rhs: ArticleViewModel) -> Bool {
        return lhs.currentArticle == rhs.currentArticle
    }
}
