//
//  MissionView.swift
//  Moonshot
//
//  Created by Diogo Melo on 27/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct MissionView: View {
        let mission: Mission
let astronauts: [CrewMember]
        
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(decorative: self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    Text("\(self.mission.formattedLaunchDate)")
                        .font(.footnote)
                    
                    Text(self.mission.description)
                        .padding()

                    Section (header: Text("Crew").accessibility(addTraits: .isHeader)) {
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, missions: crewMember.missions)) {
                        HStack {
                            Image(decorative: crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 83, height: 60)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .font(.headline)
                                Text(crewMember.role)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .padding(.horizontal)
                        .accessibility(removeTraits: .isButton)
                        .accessibility(addTraits: .isLink)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    }
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    init(mission: Mission, astronauts: [Astronaut], allMissions: [Mission]) {
        self.mission = mission

        var matches = [CrewMember]()

        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                var missions = [Mission]()
                for mission in allMissions {
                    if mission.crewList.contains(member.name) {
                        missions.append(mission)
                                            }
                }
                matches.append(CrewMember(role: member.role, astronaut: match, missions:missions))
            } else {
                fatalError("Missing \(member)")
            }
        }

        self.astronauts = matches
            }
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
        let missions: [Mission]
    }
}

struct MissionDisplayInfo: View {
    let mission: Mission
    let showDate: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(mission.displayName)
                .font(.headline)
            
            if showDate {
            Text(mission.formattedLaunchDate)
            } else {
                Text(mission.crewList)
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
        static let missions: [Mission] = Bundle.main.decode("missions.json")
        static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts, allMissions: missions)
    }
}
