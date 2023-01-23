//
//  ContentView.swift
//  Photonames
//
//  Created by Diogo Melo on 24/10/20.
//

import SwiftUI


struct ContentView: View {
    @State private var image: UIImage?
            @State private var showImagePicker = false
    @State private var showNameImage = false
    @State private var nameOfPerson = ""
    @State private var newPerson: Person?
    
    @State private var listOfPeople = [Person]()
    var body: some View {
        NavigationView {
        VStack {
            if showNameImage {
                ZStack {
                                            Image(uiImage: image!)
                            .resizable()
                            .scaledToFit()

    TextField("Name", text: $nameOfPerson)
                    
                    Button("Add") {
                        self.newPerson = Person(name: nameOfPerson, photo: image!)
                        self.listOfPeople.append(newPerson!)
                        self.listOfPeople.sort()
                        self.saveInfo()
                    }.disabled(nameOfPerson.isEmpty)
                }
            }
            List {
                ForEach (listOfPeople) { person in
                    NavigationLink(destination: PersonView(person: person)) {
                    HStack {
                        Image(uiImage: person.photo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(person.name)
                    }
                                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: namePerson) {
            ImagePicker(image: self.$image)
        }.navigationTitle("Photonames")
        .navigationBarItems(trailing: Button(action: {
            self.showImagePicker = true
        }) {
            Image(systemName: "plus")
        }.disabled(image != nil))
        }
        .onAppear(perform: loadData)
    }
    
    func namePerson() {
        if self.image != nil {
                                                self.showNameImage = true
    }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveInfo () {
        do {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPeople")
            let data = try JSONEncoder().encode(self.listOfPeople)
        try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
    } catch {
    print("Unable to save data.")
    }

        self.nameOfPerson = ""
        self.newPerson = nil
        self.image = nil
                self.showNameImage = false
    }
    
    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPeople")
        
        do {
            let data = try Data(contentsOf: filename)
            listOfPeople = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
