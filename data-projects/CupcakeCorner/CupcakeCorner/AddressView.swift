//
//  AdressView.swift
//  CupcakeCorner
//
//  Created by Diogo Melo on 2/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct AddressView: View {
        @ObservedObject var order: Order
    
    var body: some View {
        
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }

            Section {
                NavigationLink(destination: CheckOutView(order: order)) {
                    Text("Check out")
                }
            }
            .disabled(!order.hasValidAddress)
        }
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AdressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
