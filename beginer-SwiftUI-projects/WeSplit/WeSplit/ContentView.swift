//
//  ContentView.swift
//  WeSplit
//
//  Created by Diogo Melo on 8/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = 0
//    @State private var peopleText = ""
    @State private var tipPercentage = 0
    
    let tipPercentages = [0, 1, 2.5, 5, 7.5]
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
                
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var totalPerPerson: Double {
    let peopleCount = Double(numberOfPeople + 2)
//let peopleCount = Double(peopleText) ?? 1
        
let grandTotal = totalAmount
                
        return grandTotal / peopleCount
    }
    
    var body: some View {
        NavigationView {
        Form {
            Section {
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                
                Picker("Number of People", selection: $numberOfPeople) {
                    ForEach(2..<21) {
                        Text("\($0) people")
                    }
                }.pickerStyle(WheelPickerStyle())
                
//                TextField("Number of people:", text: $peopleText)
//                    .keyboardType(.numberPad)
            }
            
            Section(header: Text("Select tip percentage")) {
                Picker("Tip percentage", selection: $tipPercentage) {
                    ForEach(0..<self.tipPercentages.count) {
                        Text("\(self.tipPercentages[$0], specifier: "%g")%")
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }

            
            Section(header: Text(tipPercentage == 0 ? "Total amount:" : "Total amount :)")) {
                Text("€\(totalAmount, specifier: "%.2f")")
                    .accentColor(tipPercentage == 0 ? Color.white : Color.green)
            }
            
            Section(header: Text("Each person pays")) {
                Text("€\(totalPerPerson, specifier: "%.2f")")
            }
            }.navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
