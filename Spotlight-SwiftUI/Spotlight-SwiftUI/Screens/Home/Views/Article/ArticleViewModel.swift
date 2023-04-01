//
//  ArticleViewModel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 19.03.2023.
//

import Foundation
import Combine

class ArticleViewModel: StatefulViewModel<[Article], Error> {
    typealias State = ViewState<[Article], Error>
    private let apiService: NewsServiceProtocol
    private var currentPage = 0
    private var cancellables = [AnyCancellable]()
    
    @Published var selectedTags: [String] = NewsCategory.homeCases.filter { $0.rawValue == NewsCategory.science.rawValue }.map { $0.rawValue }
    @Published var showLoadingView: Bool = false
    
    var selectedCategories: [NewsCategory] = []
    
    init(apiService: NewsServiceProtocol) {
        self.apiService = apiService
        super.init()
        self.state = .idle
        self.selectedCategories = selectedTags.compactMap { NewsCategory(rawValue: $0) }
        
        handleFilterChanges()
    }
    
    func getMore(_ presumedLastArticle: Article) {
        guard let articles = state.payload else { return }
        let thresholdIndex = articles.index(articles.endIndex, offsetBy: -1)
        let currentIndex = articles.firstIndex(where: { $0.title == presumedLastArticle.title })
        
        guard thresholdIndex == currentIndex else { return }
        showLoadingView = true
        currentPage += 1
        getArticles(force: true)
    }
    
    func handleFilterChanges() {
        // MARK: - subscription called after return?
        $selectedTags
            .sink { [weak self] newTags in
                guard let self else { return }
                self.selectedCategories = newTags.compactMap { NewsCategory(rawValue: $0) }
                self.currentPage = 0
                self.getArticles(force: true)
            }
            .store(in: &cancellables)
    }
    
    func getArticles(force forceFetching: Bool = false) {
        if state.payload?.isEmpty ?? true {
            state = .loading
        } else if !forceFetching {
            return
        }
        
        let headlinesFilter = HeadlinesFilter(categories: selectedCategories, pageNumber: currentPage, country: .gb)
        apiService.getArticles(request: RequestType.news(headlinesFilter))
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
