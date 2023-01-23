//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by Diogo Melo on 21/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct QuestionAnswer: Equatable, Hashable {
    var question: String
    var answer: Int
    
    init (_ number1: Int, _ number2: Int) {
        question = "\(number1) x \(number2)"
        answer = number1 * number2
    }

    func isCorrect(_ answer: Int) -> Bool {
        return answer == self.answer
    }
    
    static func == (lhs: QuestionAnswer, rhs: QuestionAnswer) -> Bool {
        lhs.question == rhs.question
    }
}

let maximum_table = 12
let minimum_table = 2

struct ContentView: View {
    let possibleQuestions = ["5", "10", "20", "all"]
    @State private var inSetUp = true
    @State private var upToTable = 5
    @State private var numberOfQuestions = 5
    @State private var questionsSelector = 0
    @State private var questions = [QuestionAnswer]()
@State private var currentQuestion = 0
    @State private var currentAnswer = ""
    @State var showAnswer = false
    @State var correctAnswer = false
    @State private var points = 0
    
    var body: some View {
        Group {
            if inSetUp {
                Section {
                    Stepper("Until \(upToTable)", value: $upToTable, in: ((minimum_table + 1)...maximum_table))
                    Picker("Number of questions", selection: $questionsSelector) {
                        ForEach (0..<possibleQuestions.count) {
                            Text("\(self.possibleQuestions[$0])")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    Button ("Start!") {
                        self.createQuestions()
                                        }
                                    }
            } else {
                if !showAnswer {
                Text("\(questions[currentQuestion].question)")
                    

                    TextField("Answer", text: $currentAnswer, onCommit: verifyAnswer)
                    .keyboardType(.decimalPad)
                } else {
                    Text(correctAnswer ? "Correct!" : "Wrong :/")
                    Text("\(questions[currentQuestion].question) = \(questions[currentQuestion].answer)")
                }
                
                Text("\(points) pts in \(currentQuestion + 1)/\(numberOfQuestions)")
                Button (self.isLast() ? "Finish" : "Next") {
                    if self.isLast() {
                        self.destroy()
                                            } else {
                        self.currentQuestion += 1
                        self.showAnswer = false
                                            }
                }
            }
        }
    }
    
    func isLast() -> Bool {
        self.currentQuestion == self.questions.count - 1
    }
    func createQuestions() {
        let questionsToGenerate = possibleQuestions[questionsSelector]
        numberOfQuestions = Int(questionsToGenerate) ?? (upToTable - 1) * maximum_table
        while questions.count < numberOfQuestions {
            let tableNumber = Int.random(in: (minimum_table...upToTable))
            let multiplier = Int.random(in: (minimum_table...maximum_table))
            let newQuestion = QuestionAnswer(tableNumber, multiplier)
            if !questions.contains(newQuestion) {
            questions.append(newQuestion)
            }
        }
        inSetUp = false
    }

    func verifyAnswer() {
        let answerAsNumber = Int(currentAnswer) ?? 0
        correctAnswer = questions[currentQuestion].isCorrect(answerAsNumber)
        if correctAnswer {
            points += answerAsNumber
        } else {
            points -= questions[currentQuestion].answer
                    }
        showAnswer = true
        currentAnswer = ""
    }
    
    func destroy() {
        inSetUp = true
                        numberOfQuestions = 5
                        questions = [QuestionAnswer]()
        currentQuestion = 0
            points = 0
        showAnswer = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
