//
//  HomeViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 22.02.2022.
//

import Foundation

enum HomeSection: Int, CaseIterable {
    case headlines
    case tags
    case news
    case scrollLoading
}

class HomeViewModel {
    
    // MARK: - Private properties
    private let newsApiService: NewsServiceProtocol
    private var currentPage = 1
    
    // MARK: - Public properties
    let topHeadlines = Observable<[ArticleViewModel]>([])
    let news = Observable<[ArticleViewModel]>([])
    let topHeadlinesOnLoading = Observable<Bool>(false)
    let newsOnLoading = Observable<Bool>(false)
    let stopInfiniteScroll = Observable<Bool>(false)
    
    var tags: [NewsCategory: Bool] = [:]
    
    var numberOfSections: Int {
        return HomeSection.allCases.count
    }
    
    var selectedCategories: [NewsCategory] {
        tags.filter { $0.value == true }.map { $0.key }
    }
    
    var newsCount: Int {
        return news.value.count
    }
    
    // MARK: - Public API
    init(newsApiService: NewsServiceProtocol) {
        self.newsApiService = newsApiService
        
        tags = Dictionary(uniqueKeysWithValues: NewsCategory.allCases.map { $0.rawValue == NewsCategory.general.rawValue ? ($0, true) : ($0, false) })
        getTopHeadlines()
    }
    
    func isCategorySelected(category: NewsCategory) -> Bool {
        return tags[category] ?? false
    }
    
    func numberOfCategories() -> Int {
        return NewsCategory.allCases.count
    }
    
    func tagNameFor(index: Int) -> String {
        NewsCategory.allCases[index].rawValue.firstUppercased
    }
    
    func toggleCategory(_ category: NewsCategory, _ isSelected: Bool) {
        resetData()
        tags[category] = isSelected
    }
    
    func resetData() {
        currentPage = 1
        news.value = []
        stopInfiniteScroll.value = false
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let sectionType = HomeSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .headlines:
            return 1
        case .tags:
            return 1
        case .news:
            return news.value.count
        case .scrollLoading:
            return stopInfiniteScroll.value ? 0 : 1
        }
    }
}

// MARK: - API
extension HomeViewModel {
    
    func getTopHeadlines() {
        let headlinesFilter = HeadlinesFilter()
        headlinesFilter.country = Country.gb.rawValue
        topHeadlinesOnLoading.value = true
        
        newsApiService.getArticles(request: RequestType.news(headlinesFilter)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let news):
                let articleViewModels = news.articles.map { ArticleViewModel(article: $0) }
                self.topHeadlines.value = articleViewModels
            case .failure(let failure):
                print("Error: \(failure.localizedDescription)")
            }
            
            self.topHeadlinesOnLoading.value = false
        }
    }
    
    func getMoreNews() {
        if newsOnLoading.value || stopInfiniteScroll.value {
            // there is already an API request in progress or no more data available
            return
        }
        currentPage += 1
        getNews()
    }
    
    func getNews() {
        let headlinesFilter = HeadlinesFilter(categories: selectedCategories, pageNumber: currentPage, country: .gb)
        newsOnLoading.value = true
        
        newsApiService.getArticles(request: RequestType.news(headlinesFilter)) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let news):
                guard news.totalResults > 0 else { return }
                let articles = news.articles
                let articleViewModels = articles.map { currentArticle -> ArticleViewModel in
                    return ArticleViewModel(article: currentArticle)
                }
                self.news.value.append(contentsOf: articleViewModels)
            case .failure(let failure):
                print("Error: \(failure.localizedDescription)")
                self.stopInfiniteScroll.value = true
            }
            
            self.newsOnLoading.value = false
        }
    }
    
    private func checkIfAddedToFavorite(article: Article) -> Bool {
        return FavoriteStorageManager.shared.isAlreadyPersisted(article)
    }
}
