//
//  PhotonamesApp.swift
//  Photonames
//
//  Created by Diogo Melo on 24/10/20.
//

import SwiftUI

@main
struct PhotonamesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
