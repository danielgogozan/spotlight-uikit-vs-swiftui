//
//  ContentView.swift
//  Spotlight-SwiftUI
//
//  Created by Daniel Gogozan on 24.02.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @AppStorage("didRunBefore") private var didRunBefore = false
    let dependencyContainer: DependencyContainer
    
    var body: some View {
        ZStack {
            if didRunBefore {
                FloatingTabBar(articlesViewModel: dependencyContainer.articlesViewModel,
                               headlinesViewModel: dependencyContainer.headlinesViewModel)
            } else {
                LoginView(viewModel: LoginViewModel(apiService: AuthService(apiService: APIService()),
                                                    keychainManager: KeychainManager(keychain: Keychain())))
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(dependencyContainer: DependencyContainer.shared)
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
