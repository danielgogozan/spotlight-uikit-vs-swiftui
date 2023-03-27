//
//  APINewsService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.02.2022.
//

import Foundation
import Combine
import UIKit

protocol NewsServiceProtocol: AnyObject {
    init(apiService: APIServiceProtocol)
    
    func getArticles(request: Request) -> AnyPublisher<News, APIError>
}

class NewsService: NewsServiceProtocol {
    
    private let apiService: APIServiceProtocol
    
    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getArticles(request: Request) -> AnyPublisher<News, APIError> {
        return apiService.request(request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .print()
            .map { news in
                return news
            }
            .eraseToAnyPublisher()
    }
}
