//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Diogo Melo on 12/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

let number_of_options = 3

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    @State private var correctAnswer = Int.random(in: 0..<number_of_options)
@State private var userAnswer = -1
    @State private var victoryRotation = [Double](repeating: 0.0, count: number_of_options)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score: Double = 0
    
    var body: some View {
                ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
        VStack (spacing: 30) {
            VStack {
                Text("Tap the flag of").foregroundColor(.white)
                Text(countries[correctAnswer]).font(.largeTitle).fontWeight(.black)
            }.accessibilityElement(children: .combine)
            if userAnswer >= 0 && userAnswer != correctAnswer {
                HStack {Text("That is the flag of \(countries[userAnswer])").foregroundColor(.white)
                flagImage(country: countries[userAnswer])
                }.transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
            ForEach(0..<number_of_options) { (number: Int) in
Button(action: {
    self.userAnswer = number
                self.flagTapped(self.userAnswer, choice: self.countries[number])
    if self.userAnswer >= 0 && number == self.correctAnswer {
        withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
        self.victoryRotation[number] = 360
        }
    }
                }) {
                flagImage(country: self.countries[number])
                    .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                            }
.opacity(self.opacityValue(number))
    .animation(.default)
    .rotation3DEffect(.degrees(self.victoryRotation[number]), axis: (x: 0, y: 1, z: 0))
        }
            Spacer()
            Text("Actual score: \(score, specifier: "%.1f") points")
}
                }.alert(isPresented: $showingScore) {
                    Alert(title: Text(scoreTitle), message: Text("Your score is \(score, specifier: "%.1f") points."), dismissButton: .default(Text("Continue")) {
                        self.reshufle()
                        })
        }
    }
    func flagTapped(_ number: Int, choice country: String) {
        if number == correctAnswer {
            scoreTitle = "Correct, you really know \(country)"
            score += 1
        } else {
            scoreTitle = "Wrong, that is the flag of \(country)"
            score -= 0.5
        }
        showingScore = true
    }
    
    func reshufle() {
        userAnswer = -1
        victoryRotation = [Double](repeating: 0, count: number_of_options)
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func opacityValue(_ current: Int) -> Double {
        if userAnswer >= 0 && current != correctAnswer {
            return 0.25
        }
        return 1.0
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct flagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
                            .renderingMode(.original)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.black, lineWidth: 1))
        .shadow(color: .black, radius: 2)
        
    }
}
