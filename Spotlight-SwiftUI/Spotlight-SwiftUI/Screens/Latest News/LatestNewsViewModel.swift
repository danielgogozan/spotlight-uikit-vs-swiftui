//
//  LatestNewsViewModel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 27.03.2023.
//

import Foundation
import Combine

class LatestNewsViewModel: StatefulViewModel<[Article], Error> {
    typealias State = ViewState<[Article], Error>
    
    private let apiService: NewsServiceProtocol
    private var cancellables: [AnyCancellable] = []
    private var currentPage = 0
    @Published var showLoadingView: Bool = false
    
    let newsOnLoading = CurrentValueSubject<Bool, Never>(false)
    
    init(apiService: NewsServiceProtocol, articles: [Article] = []) {
        self.apiService = apiService
        super.init()
        
        if articles.count > 0 {
            currentPage = 1
            state = .content(articles)
        }
    }
    
    func getMore(_ presumedLastArticle: Article) {
        guard let articles = state.payload else { return }
        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -3)
        let currentIndex = articles.firstIndex(where: { $0.title == presumedLastArticle.title })
        
        guard thresholdIndex == currentIndex else { return }
        showLoadingView = true
        currentPage += 1
        getLatestNews(forceFetching: true)
    }
}

// MARK: - Private API
private extension LatestNewsViewModel {
    func getLatestNews(forceFetching: Bool = false) {
        if state.payload?.isEmpty ?? true {
            state = .loading
        } else if !forceFetching {
            return
        }
        
        let filter = HeadlinesFilter(categories: [], pageNumber: currentPage, country: .gb)
        let request = RequestType.news(filter)
        
        apiService.getArticles(request: request)
            .receive(on: RunLoop.main)
            .map { $0.articles }
            .flatMap { [weak self] articles in
                guard let self else { return Just(State.loading) }
                
                let currentArticles: [Article] = self.currentPage > 0 ? (self.state.payload ?? []) : []
                let newArticles = articles.filter { new in !currentArticles.contains { article in article.title == new.title } }
                let news = currentArticles + newArticles
                let newState = State.content(news)
                
                self.showLoadingView = false
                
                return Just(newState)
            }
            .catch { error in
                let newState = State.error(error)
                return Just(newState)
            }
            .assign(to: &$state)
    }
}
