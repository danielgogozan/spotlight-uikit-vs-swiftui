//
//  Constants.swift
//  Spotlight
//
//  Created by Daniel Gogozan on 19.02.2022.
//

import Foundation

final class Constants {
    
    // MARK: - URLs
    static let newsUrl = "https://newsapi.org/v2/"
    static let authUrl = "https://reqres.in/api/"
    
    // MARK: - Keys
    // softvision key
//    static let apiKey = "f9de2c2040254a83a883385c2a75a3f9"
    // personal key
    static let apiKey = "f004ac93811648b3abad2e3864c1a7de"
    
//    static let apiKey = "b371c827660748ac926d98bb06d03dea"
    
    // MARK: - Keychain
    static let kTokenService = "ro.spotlight"
    static let kTokenAccount = "auth"
    
    // MARK: - Mocks
    static let goodCredentials = Credentials(email: "eve.holt@reqres.in", password: "cityslicka")
}
