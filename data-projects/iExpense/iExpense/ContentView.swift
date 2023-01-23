//
//  ContentView.swift
//  iExpense
//
//  Created by Diogo Melo on 23/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
@ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                        HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                            ExpenseAmountText(amount: item.amount)
                    }
                }
                .onDelete(perform: removeItems)
            }
                .navigationBarItems(leading: EditButton(),
                    trailing:
                    Button(action: {
    self.showingAddExpense = true
                    }) {
                        Image(systemName: "plus")
                    }
                )
            .navigationBarTitle("iExpense")
        }
        .sheet(isPresented: $showingAddExpense) {
    AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
