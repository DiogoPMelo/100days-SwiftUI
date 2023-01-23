//
//  Prospect.swift
//  HotProspects
//
//  Created by Diogo Melo on 29/10/20.
//

import SwiftUI

class Prospect: Identifiable, Codable {
        let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    let creationDate = Date()
}

class Prospects: ObservableObject {
    static let saveKey = "SavedData"
    
    @Published private(set) var people: [Prospect]
    
    init() {
        // user defaults
//        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                self.people = decoded
//                return
//            }
//        }
        
        // documents direcctory
        let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
        do {
            let data = try Data(contentsOf: filename)
            self.people = try JSONDecoder().decode([Prospect].self, from: data)
            return
        } catch {
            print("Unable to load saved data.")
        }
        
        self.people = []
    }
    
    private func saveToDocumentsDirectory () {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent(Self.saveKey)
            let data = try JSONEncoder().encode(self.people)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
            }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }

    private func save() {
        saveToDocumentsDirectory()
    }
    
    func add(_ prospect: Prospect) {
    people.append(prospect)
    save()
}
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }

    func sortChronollogicaly() {
        self.people = people.sorted(by: {$0.creationDate < $1.creationDate})
    }
    
    func sortByName() {
        self.people = people.sorted(by: {$0.name < $1.name})
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
