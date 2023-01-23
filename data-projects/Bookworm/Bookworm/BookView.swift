//
//  BookView.swift
//  Bookworm
//
//  Created by Diogo Melo on 5/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI
import CoreData

struct BookView: View {
    let book: Book
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var bookDate: String {
        guard let date = book.date else {
            return "N/A"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)

                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)

                Text(self.book.review ?? "No review")
                    .padding()

                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("Rating: \(self.book.rating) star\(self.book.rating > 1 ? "s" : "")"))
                    
                Text("Reviewed on: \(self.bookDate)")
                    .font(.caption)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingDeleteAlert = true
            }) {
                Image(systemName: "trash")
                .accessibility(label: Text("Delete"))
            })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                    self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
    }
    func deleteBook() {
        moc.delete(book)

        
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct BookView_Previews: PreviewProvider {
        static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
                let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This was a great book; I really enjoyed it."

        return NavigationView {
            BookView(book: book)
        }
    }
}
