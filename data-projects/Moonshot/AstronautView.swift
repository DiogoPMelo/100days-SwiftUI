//
//  AstronautView.swift
//  Moonshot
//
//  Created by Diogo Melo on 27/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
let astronaut: Astronaut
let missions: [Mission]
    
    var body: some View {
                GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Section (header: Text("Missions").accessibility(addTraits: .isHeader)) {
                        HStack {
                        ForEach(self.missions) { mission in
                            VStack {
                                Image(decorative: mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                                Text("\(mission.displayName)")
                            }
                        }
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
        static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], missions: [])
    }
}
