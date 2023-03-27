//
//  APIService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation

protocol APIServiceProtocol {
    func request<T: Codable>(_ request: Request, completion: @escaping ((Result<T, APIError>) -> Void))
}
enum APIError: Error {
    case decodingError
    case apiError(code: Int?, message: String)
    case noData
    case unknown
}

class APIService: APIServiceProtocol {
    func request<T: Codable>(_ request: Request, completion: @escaping ((Result<T, APIError>) -> Void)) {
        guard let urlRequest = try? request.asURLRequest() else {
            print("Bad URL Request.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            if let error {
                let apiError = APIError.apiError(code: error._code, message: error.localizedDescription)
                completion(.failure(apiError))
                return
            }
            
            guard let data else { return }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}
