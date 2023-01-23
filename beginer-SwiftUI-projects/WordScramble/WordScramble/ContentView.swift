//
//  ContentView.swift
//  WordScramble
//
//  Created by Diogo Melo on 17/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var roundPoints = 0
    @State private var totalPoints = 0

    func startGame () {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                            let allWords = startWords.components(separatedBy: "\n")
                            rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
fatalError("Could not load start.txt from bundle.")
    }

    func restartGame() {
                                    startGame()
        usedWords = [String]()
        newWord = ""
        roundPoints = 0
    }
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
                    }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func extraRules(word: String) -> Bool {
        word.count > 3 && word != rootWord
    }
    
    func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else {
            return
        }
        guard isOriginal(word: answer) else {
                wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
                wordError(title: "Invalid characters present", message: "You can't just make them up, you know!")
            return
        }

        guard extraRules(word: answer) else {
            wordError(title: "Invalid word", message: "Put more effort and start to be more creative")
            return
        }
    
        guard isReal(word: answer) else {
                wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }

        usedWords.insert(answer, at: 0)
        roundPoints += answer.count
        totalPoints += answer.count
        newWord = ""
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List (usedWords, id: \.self) { word in
                    HStack {
                    Image(systemName: "\(word.count).circle")
                    Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                HStack {
                    Text("\(roundPoints) points")
                    Text("Total: \(totalPoints) points")
                }
            }
        .navigationBarTitle(rootWord)
            .navigationBarItems(leading: Button(action: restartGame) {
                Text("Next word")
            })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
            }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
