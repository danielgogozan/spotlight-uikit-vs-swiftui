//
//  LatestNewsViewModel.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 14.03.2022.
//

import Foundation
import SystemConfiguration

class LatestNewsViewModel {
    
    enum LatestNewsSection: Int, CaseIterable {
        case news
        case loading
    }
    
    private let newsApiService: NewsServiceProtocol
    private var currentPage = 0
    
    let latestNews = Observable<[ArticleViewModel]>([])
    let newsOnLoading = Observable<Bool>(false)
    let stopInfiniteScroll = Observable<Bool>(false)
    let numberOfSections = LatestNewsSection.allCases.count
    var expandedNewsIdxs: [Int] = []
    
    init(newsApiService: NewsServiceProtocol, articles: [ArticleViewModel] = []) {
        self.newsApiService = newsApiService
        
        if articles.count > 0 {
            currentPage = 1
            latestNews.value = articles
        }
    }
    
    func initLatestNews(articleViewModels: [ArticleViewModel]) {
        if articleViewModels.isEmpty {
            return
        }
        currentPage = 1
        latestNews.value = articleViewModels
    }
    
    func getMoreNews() {
        if newsOnLoading.value || stopInfiniteScroll.value {
            return
        }
        currentPage += 1
        getLatestNews()
    }
    
    func rowsInSection(_ section: Int) -> Int {
        guard let sectionType = LatestNewsSection(rawValue: section) else { return 0 }
        switch sectionType {
        case .news:
            return latestNews.value.count
        case .loading:
            return stopInfiniteScroll.value ? 0 : 1
        }
    }
    
    func sectionType(from section: Int) -> LatestNewsSection? {
        return LatestNewsSection(rawValue: section)
    }
    
    func article(at indexPath: IndexPath) -> ArticleViewModel {
        return latestNews.value[indexPath.row]
    }
    
    func toggleArticle(at index: Int) {
        if let removedIndex = expandedNewsIdxs.firstIndex(where: { $0 == index }) {
            expandedNewsIdxs.remove(at: removedIndex)
            return
        }
        expandedNewsIdxs.append(index)
    }
    
    func showFullDescription(for index: Int) -> Bool {
        return expandedNewsIdxs.contains(where: { $0 == index })
    }
    
    func onDeinit() {
        expandedNewsIdxs = []
    }
}

// MARK: - Private API
private extension LatestNewsViewModel {
    
    func getLatestNews() {
        let filter = HeadlinesFilter(categories: [], pageNumber: currentPage, country: .gb)
        let request = RequestType.news(filter)
        newsOnLoading.value = true
        
        newsApiService.getArticles(request: request) { [weak self] result in
            guard let self else { return }
            self.newsOnLoading.value = false
            switch result {
            case .success(let news):
                let articles = news.articles
                // TODO: - added to favorites check
                let articleViewModels = articles.map { ArticleViewModel(article: $0, addedToFavorite: false)}
            
                var currentNews = self.latestNews.value
                currentNews.append(contentsOf: articleViewModels)
                self.latestNews.value = currentNews
            case .failure(let error):
                print(error)
                self.stopInfiniteScroll.value = true
            }
        }
    }
}
