//
//  Spotlight_SwiftUIApp.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 24.02.2023.
//

import SwiftUI

@main
struct SpotlightSwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    let dependencyContainer = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(dependencyContainer: dependencyContainer)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class DependencyContainer {
    static let shared = DependencyContainer()
    private init() { }

    // MARK: - API
    lazy var apiService = APIService()
    lazy var newsApiService = NewsService(apiService: apiService)
    lazy var authService = AuthService(apiService: apiService)

    // MARK: - View Models
    lazy var articlesViewModel = ArticleViewModel(apiService: newsApiService)
    lazy var headlinesViewModel = HeadlineViewModel(apiService: newsApiService)
    lazy var latestNewsViewModel = LatestNewsViewModel(apiService: newsApiService)
    lazy var loginViewModel = LoginViewModel(apiService: authService, keychainManager: keychainManager)

    // MARK: - Storage Managers

    // MARK: - Keychain Manager
    lazy var keychain = Keychain()
    lazy var keychainManager = KeychainManager(keychain: keychain)
}
