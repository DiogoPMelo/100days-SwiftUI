//
//  ItemDetail.swift
//  iDine
//
//  Created by Diogo Melo on 21/3/21.
//

import SwiftUI

struct ItemDetail: View {
    @EnvironmentObject var order: Order
    let item: MenuItem
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottomTrailing) {
                Image(decorative: item.mainImage)
                    .resizable()
                    .scaledToFit()
                
                
                Text("Photo: \(item.photoCredit)")
                                        .padding(4)
                    .background(Color.black)
                    .font(.caption)
                    .foregroundColor(.white)
                    .offset(x: -5, y: -5)
            }

            Text(item.description)
                .padding()
            
            Button ("Order this") {
                order.add(item: item)
            }
            .font(.headline)
            
            Spacer()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetail(item: MenuItem.example).environmentObject(Order())
        }
    }
}
