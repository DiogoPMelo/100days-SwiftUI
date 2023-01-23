//
//  ContentView.swift
//  Moonshot
//
//  Created by Diogo Melo on 25/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")

    @State private var showDate = false
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts, allMissions: self.missions)) {
                    Image(decorative: mission.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 44, height: 44)

                    MissionDisplayInfo(mission: mission, showDate: self.showDate)
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing:
                Button(action: { self.showDate.toggle()
                }) {
                    if showDate {
                    Image(systemName: "plus")
                        .accessibility(label: Text("More info"))
                        .accessibility(hint: Text("Shows the crew"))
                    } else {
                        Image(systemName: "clock")
                        .accessibility(label: Text("Dates"))
                        .accessibility(hint: Text("Shows the launch date"))
                    }
            })
        }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
