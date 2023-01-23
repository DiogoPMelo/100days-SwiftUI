//
//  ContentView.swift
//  RockPaperSisors
//
//  Created by Diogo Melo on 13/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

enum Jogada: Int {
    case rock, paper, scissors
}

enum Result {
    case win, draw, loss
}

func result (_ cpu: Jogada, vs player: Jogada) -> Result {
    if cpu.rawValue == player.rawValue {
        return Result.draw
    } else if cpu.rawValue == player.rawValue + 1 || cpu.rawValue == player.rawValue - 2 {
        return Result.loss
    } else {
        return Result.win
    }
    }

let jogadas = ["Rock", "Paper", "Scissors"]
let number_of_turns = 10

struct ContentView: View {
    @State private var cpuTurn = Int.random(in: 0...2)
    @State private var winLose = Bool.random()
    @State private var points: Int = 0
    @State var turnsPlayed = 1
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
        VStack  {
            Section(header: Text("CPU played")) {
            Text(jogadas[cpuTurn])
            }
            Section (header: Text("Try to")) {
                        Text(winLose ? "Win" : "Lose")
            }
                        HStack {
                ForEach(0..<3) { number in
                    Button(jogadas[number]) {
                        let expectedResult = self.winLose ? Result.win : Result.loss
                        let obtainedResult = result(Jogada(rawValue: self.cpuTurn)!, vs: Jogada(rawValue: number)!)
                        self.showAlert = self.turnsPlayed == number_of_turns
                        if !self.showAlert {
                        self.turnsPlayed += 1
                        }
                                                                        if expectedResult == obtainedResult {
                            self.points += 1
                        } else {
                            self.points -= 1
                        }
                        self.replay()
                    }
                }
            }
            Text("\(points) points")
            Text("Turn \(turnsPlayed)/\(number_of_turns)")
            }.navigationBarTitle("Rock Paper Scissors")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("You finished round \(turnsPlayed)"), message: Text("\(points)/\(turnsPlayed) points"), dismissButton: .default(Text("Restart")) {
                    self.restart()
                })
            }
        }
    }
    
    func replay() {
        winLose = Bool.random()
        cpuTurn = Int.random(in: 0...2)
    }
    func restart() {
        turnsPlayed = 1
        points = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
