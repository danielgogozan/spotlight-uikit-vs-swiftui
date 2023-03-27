//
//  APINewsService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 21.02.2022.
//

import Foundation

protocol NewsServiceProtocol: AnyObject {
    init(apiService: APIServiceProtocol)
    func getArticles(request: Request, completion: @escaping ((Result<News, APIError>) -> Void))
}

class NewsService: NewsServiceProtocol {
    private let apiService: APIServiceProtocol
    
    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func getArticles(request: Request, completion: @escaping ((Result<News, APIError>) -> Void)) {
        apiService.request(request, completion: completion)
    }
}
