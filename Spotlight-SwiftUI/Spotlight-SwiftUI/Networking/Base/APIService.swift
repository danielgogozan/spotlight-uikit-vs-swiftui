//
//  APIService.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func request<T: Codable>(_ request: Request) -> AnyPublisher<T, APIError>
}
enum APIError: Error {
    case decodingError
    case apiError(code: Int?, message: String)
    case noData
    case unknown
}

class APIService: APIServiceProtocol {
    
    // swiftlint:disable force_try
    func request<T: Codable>(_ request: Request) -> AnyPublisher<T, APIError> {
        return URLSession.DataTaskPublisher(request: try! request.asURLRequest(), session: .shared)
            .print()
            .tryCompactMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.unknown
                }
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.decodingError
                }
            }
            .mapError { error -> APIError in
                return APIError.apiError(code: nil, message: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    // swiftlint:enable force_try
}
