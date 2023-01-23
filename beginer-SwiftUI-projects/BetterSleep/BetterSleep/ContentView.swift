//
//  ContentView.swift
//  BetterSleep
//
//  Created by Diogo Melo on 14/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

func convertToTime (_ time: Double) -> String {
    let hours = Int(time)
    let minutes = Int((time - Double(hours)) * 60)
    let minutesString = minutes == 0 ? "00" : "\(minutes)"
    return "\(hours)h \(minutesString)min"
}
struct ContentView: View {
    @State private var sleepAmount = 8.0
@State private var wakeUp = defaultWakeTime
@State private var coffeeAmount = 0
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    // from day28
//            @State private var sleepAmountIndex = 0
    var sleepAmountList: [Double] {
        var list: [Double] = []
        var number = 4.0
        let final = 12.0
        let steper = 0.25
        while number <= final {
            list.append(number)
            number += steper
        }
                return list
}
    
//    var sleepAmountFromIndex: Double {
//        sleepAmountList[sleepAmountIndex]
//    }
        
        func returnBedTime () throws -> String {
    let model = SleepCalculator()
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
                                let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))

            
                let sleepTime = wakeUp - prediction.actualSleep
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter.string(from: sleepTime)
            }
    
    func calculateBedTime () {

        do {
                let prediction = try returnBedTime()
            alertMessage = prediction
            alertTitle = "Your ideal bedtime is…"
                    } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        showingAlert = true
    }
    
    var sleepTime: String {
        do {
            return try returnBedTime()
        } catch {
            return ""
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 6
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var body: some View {
        NavigationView {
        Form {
            Section (header: Text("When do you want to wake up").font(.headline)) {
                DatePicker("Please select a date", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
            }
            Section (header: Text("Desired sleep time").font(.headline)) {
            Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                Text("\(convertToTime(sleepAmount))")
        }
            .accessibility(value: Text(convertToTime(sleepAmount)))
//                Picker ("", selection: $sleepAmountIndex) {
//                    ForEach(0..<self.sleepAmountList.count) {
//                        Text("\(self.sleepAmountList[$0], specifier: "%g") hours")
//                    }
//                }.pickerStyle(WheelPickerStyle())
            }
            
            Section (header:             Text("Coffee consumption").font(.headline)) {
            Stepper(value: $coffeeAmount, in: 0...20) {
                if coffeeAmount == 1 {
                    Text("1 cup")
                } else {
                Text("\(coffeeAmount) cups")
                }
            }
            .accessibility(value: Text("\(coffeeAmount) \(coffeeAmount == 1 ? "cup" : "cups")"))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Bed time").font(.largeTitle)
                Text("\(sleepTime)").font(.headline)
            }
            }.navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                Button(action: calculateBedTime) {
//                    Text("Calculate")
//            })
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
