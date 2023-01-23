//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Diogo Melo on 13/9/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct CapsuleText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct largeTitleExercise: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).foregroundColor(Color.blue)
    }
}

extension View {
    func greatTitle24() -> some View {
        self.modifier(largeTitleExercise())
    }
}

struct ContentView: View {
    @State private var useRedText = false

    @State var agreedToTerms = false
    @State var agreedToPrivacyPolicy = false
    @State var agreedToEmails = false
    let text1 = CapsuleText(text: "One")
    let text2 = CapsuleText(text: "Two")
    
    var players = ["Ronaldo", "Cantona", "Beckham"]
    
    var body: some View {
        let agreedToAll = Binding<Bool>(
            get: {
                self.agreedToTerms && self.agreedToPrivacyPolicy && self.agreedToEmails
            },
            set: {
                self.agreedToTerms = $0
                self.agreedToPrivacyPolicy = $0
                self.agreedToEmails = $0
            }
        )
        
        return VStack {
            HStack {
            Button(useRedText ? "Hello World" : "Bye world") {
                    
                    self.useRedText.toggle()
                }
                .foregroundColor(useRedText ? .red : .blue)
                
                Toggle(isOn: $agreedToTerms) {
                    Text("Agree to terms")
                }

                Toggle(isOn: $agreedToPrivacyPolicy) {
                    Text("Agree to privacy policy")
                }

                Toggle(isOn: $agreedToEmails) {
                    Text("Agree to receive shipping emails")
                }

                Toggle(isOn: agreedToAll) {
                    Text("Agree to all")
                }
            }
            VStack {
text1
                text2.font(.largeTitle)
                Text("Three").titleStyle()
                Text("Custom title view from day 24").greatTitle24()
            }.font(.title)
            GridStack(rows: 4, columns: 4) { row, col in
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
            }
            VStack {
                ForEach(self.players, id: \.self) {
                    Text($0)
                }
            }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}
