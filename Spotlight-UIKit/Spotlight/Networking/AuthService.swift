//
//  AuthService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.05.2022.
//

import Foundation

protocol AuthServiceProtocol {
    init(apiService: APIServiceProtocol)
    func login(with credentials: Credentials, completion: @escaping (Result<Token, APIError>) -> Void)
}

class AuthService: AuthServiceProtocol {
    let apiService: APIServiceProtocol
    
    required init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func login(with credentials: Credentials, completion: @escaping (Result<Token, APIError>) -> Void) {
        let request = RequestType.login(credentials)
        apiService.request(request, completion: completion)
    }
}
