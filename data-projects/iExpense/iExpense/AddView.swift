//
//  AddView.swift
//  iExpense
//
//  Created by Diogo Melo on 24/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
@State private var badInfoAlert = false
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
@ObservedObject var expenses: Expenses
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
                NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                TextField("Amount", text: $amount, onCommit: submitExpense)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
                    .navigationBarItems(trailing: Button("Save", action: submitExpense))
        }
                .alert(isPresented: $badInfoAlert) {
                    Alert(title: Text("Invallid amount"),
                          message: Text("Please enter a valid expense amount"),
                          dismissButton: .default(Text("Ok")))
        }
    }
    
    func submitExpense() {
        guard let actualAmount = Int(self.amount)  else {
            badInfoAlert = true
            amount = ""
            return
        }
            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
            self.expenses.items.append(item)
            self.presentationMode.wrappedValue.dismiss()
            }
}

struct ExpenseAmountText: View {
    var amount: Int
    
    var body: some View {
        let text = Text("€\(amount)")
        if amount > 1000 {
            return text
                .foregroundColor(.red)
        } else if amount > 100 {
            return text
                .foregroundColor(.yellow)
        } else {
            return text
                .foregroundColor(.blue)
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
