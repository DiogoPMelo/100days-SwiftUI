//
//  ContentView.swift
//  AccessibilityProject
//
//  Created by Diogo Melo on 18/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096"
    ]
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
            @State private var selectedPicture = Int.random(in: 0...3)
    
    @State private var estimate = 25.0
    @State private var rating = 3
        
    var body: some View {
        VStack {
        Text("selected image #\(selectedPicture)")
            .accessibility(addTraits: .isSummaryElement)
            .accessibility(addTraits: .isHeader)
            Image(pictures[selectedPicture])
            .resizable()
            .scaledToFit()
            .accessibility(label: Text(labels[selectedPicture]))
            .accessibility(addTraits: .isButton)
            .accessibility(removeTraits: .isImage)
                .accessibility(addTraits: .allowsDirectInteraction )
                            .onTapGesture {
                self.selectedPicture = Int.random(in: 0...3)
        }
                        HStack {
                Image(decorative: "character")
                            Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            .accessibilityElement(children: .combine)
                        .accessibilityAction(named: Text("3rd image"), {
                            selectedPicture = 3
                        })
                        .accessibilityAction(named: Text("2nd image"), {
                        selectedPicture = 2
                        })
                        .accessibilityAction(named: Text("1st image"), {
                            selectedPicture = 1
                        })
                                                            HStack {
                Image(decorative: "character")
                Text("Your score is")
                Text("9001")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Your score is over 9000"))
            .accessibility(hint: Text("\(selectedPicture > 0 ? "Reset image" : "")"))
            .accessibility(addTraits: selectedPicture > 0 ? .isButton : .isSelected)
                                                            .accessibility(addTraits: .isKeyboardKey)
                                    .accessibility(sortPriority: 1)
                                                .accessibilityAction{
                self.selectedPicture = 0
            }
            Slider(value: $estimate, in: 0...50)
                .padding()
                            .accessibility(value: Text("\(Int(estimate))"))
                Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
            .accessibility(value: Text("\(rating) out of 5"))
                        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
