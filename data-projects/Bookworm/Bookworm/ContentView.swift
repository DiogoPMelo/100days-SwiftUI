//
//  ContentView.swift
//  Bookworm
//
//  Created by Diogo Melo on 4/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \Book.rating, ascending: false),
        NSSortDescriptor(keyPath: \Book.title, ascending: true),
        NSSortDescriptor(keyPath: \Book.author, ascending: true)]) var books: FetchedResults<Book>

    @State private var showingAddScreen = false
    
    var body: some View {
    NavigationView {
       List {
           ForEach(books, id: \.self) { book in
               NavigationLink(destination: BookView(book: book)) {
                HStack {
                EmojiRatingView(rating: book.rating)
                       .font(.largeTitle)

                   VStack(alignment: .leading) {
                       Text(book.title ?? "Unknown Title")
                           .font(.headline)
                        .foregroundColor(book.rating < 2 ? .red : .black)
                       Text(book.author ?? "Unknown Author")
                           .foregroundColor(.secondary)
                   }
                }
                .accessibilityElement(children: .ignore)
                .accessibility(label: Text("\(book.title ?? "unknown"), \(book.author ?? "unknown"): \(book.rating) star\(book.rating > 1 ? "s" : "")"))
               }
           }
        .onDelete(perform: deleteBooks)
       }
           .navigationBarTitle("Bookworm")
           .navigationBarItems(leading: EditButton(), trailing: Button(action: {
               self.showingAddScreen.toggle()
           }) {
               Image(systemName: "plus")
            .accessibility(label: Text("Add book"))
           })
           .sheet(isPresented: $showingAddScreen) {
               AddBookView().environment(\.managedObjectContext, self.moc)
           }
   }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            
            let book = books[offset]

            
            moc.delete(book)
        }

        
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
