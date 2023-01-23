//
//  PersonView.swift
//  Photonames
//
//  Created by Diogo Melo on 25/10/20.
//

import SwiftUI

struct PersonView: View {
    let person: Person
    var body: some View {
        VStack {
            Image(uiImage: person.photo)
                .resizable()
                .scaledToFit()
            Text(person.name)
                    }
    }
}
