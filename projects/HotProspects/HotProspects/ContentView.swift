//
//  ContentView.swift
//  HotProspects
//
//  Created by Diogo Melo on 28/10/20.
//

import SwiftUI

struct ContentView: View {
    var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Image(systemName: "person.3")
                        .accessibilityLabel(Text("Everyone"))
                    Text("Everyone")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Image(systemName: "checkmark.circle")
                        .accessibilityLabel(Text("Contacted"))
                    Text("Contacted")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Image(systemName: "questionmark.diamond")
                        .accessibilityLabel(Text("Uncontacted"))
                    Text("Uncontacted")
                }
            MeView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                        .accessibilityLabel(Text("Me"))
                    Text("Me")
                }
        }
        .environmentObject(prospects)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
