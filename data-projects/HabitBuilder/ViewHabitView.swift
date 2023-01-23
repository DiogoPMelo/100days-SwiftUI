//
//  ViewHabitView.swift
//  HabitBuilder
//
//  Created by Diogo Melo on 1/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ViewHabitView: View {

    @ObservedObject var habitList: HabitList
    @State var habit: Habit
    
    var body: some View {
        NavigationView {
        Form {
            Text(habit.title)
                .font(.title)

            Text(habit.description)
                .font(.body)
            
            HStack {
                VStack {
                Text("\(habit.repetitions) accomplished of")
                Text("\(habit.desiredTimes) desired")
                }
                Spacer()
                
                VStack {
                Button("Build") {
                    self.habit.buildHabit()
                    self.syncWithList()
                                    }
                    Button("Reset") {
                    self.habit.resetCount()
                    self.syncWithList()
                                    }
                }
            }
            }
        }
    }
    
    func syncWithList() {
                            if let findInList = self.habitList.habits.firstIndex(where: {
            $0.id == self.habit.id
        }) {
                                self.habitList.habits[findInList].repetitions = self.habit.repetitions
                                self.habit = self.habitList.habits[findInList]
        }
    }

}


struct ViewHabitView_Previews: PreviewProvider {
    static var previews: some View {
        ViewHabitView(habitList: HabitList(), habit: Habit(title: "Test", description: "", desiredTimes: 5))
    }
}
