//
//  Mission.swift
//  Moonshot
//
//  Created by Diogo Melo on 26/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }

    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }

    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        if let launchDate = launchDate {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            return formatter.string(from: launchDate)
        } else {
            return "N/A"
        }
    }
    
    var crewList: String {
        var names = ""
        for member in self.crew {
            names += "\(member.name), "
        }
        return names.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters)
    }
}
