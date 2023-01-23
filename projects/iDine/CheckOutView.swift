//
//  CheckOutView.swift
//  iDine
//
//  Created by Diogo Melo on 22/3/21.
//

import SwiftUI

struct CheckOutView: View {
    @EnvironmentObject var order: Order
    
    let paymentTypes = ["Cash", "Credit Card", "iDine points"]
    @State private var paymentType = "Cash"
    
    @State private var addLoyaltyDetails = false
    @State private var loyaltyNumber = ""
    
    let tipAmounts = [10, 15, 20, 25, 0]
    @State private var tipAmount = 15
    
    @State private var showPaymentAlert = false
    
    var totalPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        let total = Double(order.total)
        let tipValue = total / 100 * Double(tipAmount)
        
        return formatter.string(from: NSNumber(value: total + tipValue)) ?? "$0"
    }
    
    var body: some View {
        Form {
            Section {
                Picker ("How do you want to pay", selection: $paymentType) {
                    ForEach(paymentTypes, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(WheelPickerStyle())
                
                Toggle ("add iDine loyalty card",                 isOn: $addLoyaltyDetails.animation())
                
                if addLoyaltyDetails {
                TextField("Enter your iDine ID", text: $loyaltyNumber)
                }
                
                Section (header: Text("Add a tip?")) {
                    Picker ("Percentage", selection: $tipAmount) {
                        ForEach (tipAmounts, id: \.self) {
                            Text("\($0)%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section (header:
                            Text("Total: \(totalPrice)").font(.largeTitle))
                {
                    Button ("Confirm order") {
                        showPaymentAlert.toggle()
                    }
                }
            }
        }
        .alert(isPresented: $showPaymentAlert) {
            Alert(title: Text("Order confirmed"),
                  message: Text("Your total was \(totalPrice). Thank you!"),
                  dismissButton: .default(Text("Ok")))
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckOutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutView().environmentObject(Order())
    }
}
