//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Diogo Melo on 28/10/20.
//

import SwiftUI

@main
struct HotProspectsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
