//
//  ContentView.swift
//  HabitBuilder
//
//  Created by Diogo Melo on 29/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var habitList = HabitList()
    @State var showAddHabit = false
    
    var body: some View {
        NavigationView {
            List {
            ForEach(habitList.habits) { habit in
                NavigationLink (
                destination: ViewHabitView(habitList: self.habitList, habit: habit)) {
                HStack {
                Text("\(habit.title)")
                    .font(.subheadline)
                    Spacer()
                    

                    Text("\(habit.repetitions)/\(habit.desiredTimes)")
                        .font(.caption)

                }
                }
            }
                .onDelete(perform: removeItems)
            }
        .navigationBarTitle("HabitBuilder")
        .navigationBarItems(trailing:
            Button (action: {
                                self.showAddHabit = true
            }){
                Image(systemName: "plus")
                    .accessibility(label: Text("Add habit"))
        })
        }
        .sheet(isPresented: $showAddHabit) {
            AddHabitView(habitList: self.habitList)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        habitList.habits.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
