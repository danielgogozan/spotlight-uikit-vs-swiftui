//
//  SearchResultsViewModel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 31.03.2023.
//

import Foundation
import Combine

struct FilterData {
    var query: String
    var selectedCategory: NewsCategory
    var selectedSortCategory: Sorter?
    var selectedLanguageCategory: Language?
}

class SearchResultsViewModel: StatefulViewModel<[Article], Error> {
    typealias State = ViewState<[Article], Error>
    private let apiService: NewsServiceProtocol
    private(set) var filterData: FilterData
    
    @Published var totalResults: Int = 0
    @Published var selectedTags: [String] = NewsCategory.allCases.filter { $0.rawValue == NewsCategory.filter.rawValue }
                                                        .map { $0.rawValue.capitalized }
    @Published var showLoadingView: Bool = false
    private var currentPage = 1
    private var cancellables = [AnyCancellable]()
    
    let headlines: [Article] = [Article(author: "Auth2", title: "Title1", description: "Desc1"),
                                Article(author: "Auth3", title: "Title2", description: "Desc1"),
                                Article(author: "Auth4", title: "Title3", description: "Desc1"),
                                Article(author: "Auth5", title: "Title4", description: "Desc1"),
                                Article(author: "Auth6", title: "Title5", description: "Desc1"),
                                Article(author: "Auth7", title: "Title6", description: "Desc1"),
                                Article(author: "Auth8", title: "Title7", description: "Desc1"),
                                Article(author: "Auth9", title: "Title8", description: "Desc1")]
    
    var tags: [String] {
        NewsCategory.allCases.map { $0.rawValue.capitalized }
    }
    
    init(apiService: NewsServiceProtocol, filterData: FilterData) {
        self.apiService = apiService
        self.filterData = filterData
        super.init()
        self.state = .content(headlines)
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
    
    func updateFilter(with newFilter: FilterData) {
        filterData = newFilter
        currentPage = 1
        getArticles(force: true)
    }
    
    func handleFilterChanges() {
        $selectedTags
            .sink { [weak self] newTags in
                guard let self else { return }
                var newFilterData = self.filterData
                newFilterData.selectedCategory = newTags.compactMap { NewsCategory(rawValue: $0) }.first ?? self.filterData.selectedCategory
                self.updateFilter(with: newFilterData)
            }
            .store(in: &cancellables)
    }
    
    func getArticles(force forceFetching: Bool = false) {
        return
        if state.payload?.isEmpty ?? true {
            state = .loading
        } else if !forceFetching {
            return
        }
        
        let newsFilter = buildFilter()
        apiService.getArticles(request: RequestType.news(newsFilter))
            .receive(on: RunLoop.main)
            .map { [weak self] result -> [Article] in
                self?.totalResults = result.totalResults
                return result.articles
            }
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
    
    func buildFilter() -> BaseNewsFilter {
        if filterData.selectedCategory == .filter {
            return NewsFilter(query: filterData.query,
                              pageNumber: currentPage,
                              sortBy: filterData.selectedSortCategory,
                              language: filterData.selectedLanguageCategory)
        }
        
        return HeadlinesFilter(categories: [filterData.selectedCategory],
                               pageNumber: currentPage,
                               query: filterData.query,
                               country: nil)
    }
}
