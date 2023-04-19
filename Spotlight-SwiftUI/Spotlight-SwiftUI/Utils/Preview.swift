//
//  Preview.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 13.03.2023.
//

import Foundation


extension APIServiceProtocol where Self == APIService {
    static var preview: APIServiceProtocol {
        APIService()
    }
}

extension AuthServiceProtocol where Self == AuthService {
    static var preview: AuthServiceProtocol {
        AuthService(apiService: .preview)
    }
}

extension NewsServiceProtocol where Self == NewsService {
    static var preview: NewsServiceProtocol {
        NewsService(apiService: .preview)
    }
}

extension HeadlineViewModel {
    static var preview: HeadlineViewModel {
        HeadlineViewModel(apiService: .preview)
    }
}

extension ArticleViewModel {
    static var preview: ArticleViewModel {
        ArticleViewModel(apiService: .preview)
    }
}

extension LatestNewsViewModel {
    static var preview: LatestNewsViewModel {
        LatestNewsViewModel(apiService: .preview, articles: [])
    }
}
