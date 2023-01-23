//
//  OrderView.swift
//  iDine
//
//  Created by Diogo Melo on 22/3/21.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var order: Order
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach (order.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text("$\(item.price)")
                        }.accessibilityElement(children: .combine)
                    }
                    .onDelete(perform: deleteItems)
                                    }
                
                Section {
                    NavigationLink (destination: CheckOutView()) {
                        Text("Place order")
                    }
                }.disabled(order.items.isEmpty)
                
                
                            }
            .navigationTitle("Order")
            .listStyle(InsetListStyle())
            .toolbar{
                EditButton()
            }
        }
    }
    
    func deleteItems (at offsets: IndexSet) {
        order.items.remove(atOffsets: offsets)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView().environmentObject(Order())
    }
}
