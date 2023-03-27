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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
