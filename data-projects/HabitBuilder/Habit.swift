//
//  Habit.swift
//  HabitBuilder
//
//  Created by Diogo Melo on 29/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    
    var title: String
    var description: String
    var repetitions = 0
    var desiredTimes: Int
    
    mutating func buildHabit() {
        repetitions += 1
    }
    
    
    mutating func resetCount() {
        repetitions = 0
    }
    
    mutating func increaseFreq() {
        desiredTimes += 1
    }
    
    mutating func decreaseFreq() {
        desiredTimes -= 1
    }
        }

class HabitList: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "habits")
            }
        }
    }
    
    init() {
    if let habits = UserDefaults.standard.data(forKey: "habits") {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Habit].self, from: habits) {
            self.habits = decoded
            return
        }
    }

            self.habits = []
}
}
