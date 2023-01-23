//
//  AddBookView.swift
//  Bookworm
//
//  Created by Diogo Melo on 5/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.managedObjectContext) var moc
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    @State private var showInvallidInfo = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    RatingView(rating: $rating)
                    TextField("Write a review", text: $review)
                }

                Section {
                    Button("Save") {
                        guard !self.title.isEmpty && !self.author.isEmpty && !self.genre.isEmpty else {
                            self.showInvallidInfo = true
                            return
                        }
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        newBook.date = Date()

                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(genre.isEmpty)
            }
            .navigationBarTitle("Add Book")
        }.alert(isPresented: $showInvallidInfo) {
            Alert(title: Text("Invalid book information"),
                  message: Text("Verify if title, author or genre are filled in"),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
