//
//  iDineApp.swift
//  iDine
//
//  Created by Diogo Melo on 16/2/21.
//

import SwiftUI

@main
struct iDineApp: App {
    @StateObject var order = Order()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(order)
        }
    }
}
