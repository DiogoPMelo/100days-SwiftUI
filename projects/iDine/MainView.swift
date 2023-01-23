//
//  MainView.swift
//  iDine
//
//  Created by Diogo Melo on 22/3/21.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTag = 2
    var body: some View {
        TabView (selection: $selectedTag) {
            ContentView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }.tag(1)
            
            OrderView()
                .tabItem {
                    Label("Order", systemImage: "square.and.pencil")
                }.tag(2)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(Order())
    }
}
