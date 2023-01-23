//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Diogo Melo on 25/12/20.
//

import SwiftUI

class Favorites: ObservableObject {
    static let saveKey = "FavoritesData"
    private var resorts: Set<String>
    
    init() {
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        do {
            let data = try Data(contentsOf: filename)
            self.resorts = try JSONDecoder().decode(Set<String>.self, from: data)
            return
        } catch {
            print("Unable to load saved data.")
        }
        
        self.resorts = []
    }
        
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try JSONEncoder().encode(self.resorts)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }

}


func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
