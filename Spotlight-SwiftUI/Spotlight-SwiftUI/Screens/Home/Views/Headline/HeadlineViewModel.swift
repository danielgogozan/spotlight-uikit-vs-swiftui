//
//  HeadlineViewModel.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 19.03.2023.
//

import Foundation
import Combine

class HeadlineViewModel: StatefulViewModel<[Article], Error> {
    typealias State = ViewState<[Article], Error>
    private let apiService: NewsServiceProtocol
    
    init(apiService: NewsServiceProtocol) {
        self.apiService = apiService
    }
    
    
    var latestNewsViewModel: LatestNewsViewModel {
        LatestNewsViewModel(apiService: apiService,
                            articles: state.payload ?? [])
    }
    
    func getTopHeadlines() {
        guard state.payload?.isEmpty ?? true else { return }
        let headlinesFilter = HeadlinesFilter()
        headlinesFilter.country = Country.ro.rawValue
        state = .loading
        
        apiService.getArticles(request: RequestType.news(headlinesFilter))
            .receive(on: RunLoop.main)
            .map { $0.articles }
            .flatMap { articles in
                let newState = State.content(articles)
                return Just(newState)
            }
            .catch { error in
                let newState = State.error(error)
                return Just(newState)
            }
            .prepend(.loading)
            .assign(to: &$state)
    }
}
