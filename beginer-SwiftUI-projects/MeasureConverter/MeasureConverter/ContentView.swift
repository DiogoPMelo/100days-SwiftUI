//
//  ContentView.swift
//  MeasureConverter
//
//  Created by Diogo Melo on 10/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

let SECONDS_IN_HOUR: Double = 60 * 60

struct ContentView: View {
    @State private var inputMeasurement = ""
    @State private var fromSelection = 2
    @State private var toSelection = 3

    let units = ["Second", "Minute", "Hour", "WorkDay", "Day"]
    let timeMultipliers: [Double] = [1, 60, SECONDS_IN_HOUR, SECONDS_IN_HOUR * 8, SECONDS_IN_HOUR * 24]
    
    var originalInSeconds: Double {
let originalValue = Double(inputMeasurement) ?? 0
        
        return originalValue * timeMultipliers[fromSelection]
    }
    
    var convertedValue: Double {
        originalInSeconds / timeMultipliers[toSelection]
    }
    var body: some View {
        let selectionsBinding = Binding(
            get: {
                self.fromSelection
        }, set: {
            self.fromSelection = $0
            if self.fromSelection == self.toSelection {
                let direction = self.toSelection == self.units.count - 1 ? -1 : 1
                self.toSelection = self.fromSelection + direction
            }
        })
        
        return NavigationView {
            Form {
                Section (header: Text("Insert a value to convert:")) {
                    TextField("value to convert", text: $inputMeasurement)
                        .keyboardType(.decimalPad)
                    
                    Picker ("Input time unit", selection: selectionsBinding) {
                        ForEach(0..<units.count) {
                            Text("\(self.units[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                 
                Section (header: Text("Convert to")) {
                    Picker ("convert to", selection: $toSelection) {
                        ForEach(0..<units.count) {
                            Text("\(self.units[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(convertedValue, specifier: "%.3f") \(units[toSelection])s")
                }
            }.navigationBarTitle("TimeConverter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
