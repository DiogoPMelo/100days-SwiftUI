//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Diogo Melo on 2/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var order = Order()
    
    var body: some View {
NavigationView {
    Form {
        Section {
            Picker("Cake type", selection: $order.type) {
                ForEach(0..<Order.types.count) {
                    Text(Order.types[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())

            Stepper(value: $order.quantity, in: 3...20) {
                Text("Number of cakes: \(order.quantity)")
                                                }
        .accessibility(label: Text("Number of cakes"))
            .accessibility(value: Text("\(order.quantity) \(order.quantity > 1 ? "cakes" : "cake")"))
        }
        
        Section {
            Toggle(isOn: $order.specialRequestEnabled.animation()) {
                Text("Any special requests?")
            }
            
            if order.specialRequestEnabled {
                Toggle(isOn: $order.extraFrosting) {
                    Text("Add extra frosting")
                }

                Toggle(isOn: $order.addSprinkles) {
                    Text("Add extra sprinkles")
                }
            }
        }
        
        Section {
            NavigationLink(destination: AddressView(order: order)) {
                Text("Delivery details")
            }
        }
    }
    .navigationBarTitle("Cupcake Corner")
}
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
