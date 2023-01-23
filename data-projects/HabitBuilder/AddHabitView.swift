//
//  AddHabitView.swift
//  HabitBuilder
//
//  Created by Diogo Melo on 29/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var habitList: HabitList
    @State var title = ""
    @State var description = ""
    @State var repetitions = 7
    
    var body: some View {
        NavigationView {
        Form {
            TextField("Title", text: $title)
                .font(.headline)

            TextField("description", text: $description)
                .font(.body)
            
            Stepper (value: $repetitions, in: 1...28) {
                Text("\(repetitions) repetitions")
            }
            }.navigationBarTitle("New Habit")
            .navigationBarItems(trailing:
            Button("Add") {
                self.addHabit()
            })
        }
    }
    func addHabit() {
        let newHabit = Habit(title: self.title, description: self.description, desiredTimes: self.repetitions)
        self.habitList.habits.append(newHabit)
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habitList: HabitList())
    }
}
