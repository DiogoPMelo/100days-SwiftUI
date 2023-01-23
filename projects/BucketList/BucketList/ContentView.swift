//
//  ContentView.swift
//  BucketList
//
//  Created by Diogo Melo on 17/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI
import LocalAuthentication
import MapKit

struct ContentView: View {
    @State private var centerCoordinate = CLLocationCoordinate2D()
@State private var locations = [CodableMKPointAnnotation]()
    @State private var selectedPlace: MKPointAnnotation?
    
    @State private var isUnlocked = false
    @State private var showingPlaceDetails = false
    @State private var showingEditScreen = false
    @State private var showList = false
    
    var buttonsToList: [ActionSheet.Button] {
        var list = [ActionSheet.Button]()
        for location in locations {
            list.append(.default(Text("\(location.wrappedTitle)")) {
                                self.centerCoordinate = location.coordinate
                                                })
        }
        list.append(.cancel())
        return list
    }
    
    var body: some View {
        ZStack {
            MapView(centerCoordinate: $centerCoordinate, selectedPlace: $selectedPlace, showingPlaceDetails: $showingPlaceDetails, annotations: locations)
                .edgesIgnoringSafeArea(.all)
            Circle()
                .fill(Color.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            VStack {
                if false {
                    List {
                        ForEach(locations, id: \.self) { location in
                            Text("originally to put my places")
                        }
                    }
                } else {
                Spacer()
                }
                HStack {
                    Spacer()
                    if isUnlocked {
                        Button("My Places") {
                            self.showList = true
                        }
                        Button(action: {
                        let newLocation = CodableMKPointAnnotation()
                        newLocation.coordinate = self.centerCoordinate
                                                self.locations.append(newLocation)
                        self.selectedPlace = newLocation
                        self.showingEditScreen = true
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                            .accessibility(label: Text("Add Place (\(locations.count))"))
                    }
                    } else {
                        Button ("Unlock") {
                            self.authenticate()
                        }                            .padding()
                            .background(Color.black.opacity(0.75))
                            .foregroundColor(.white)
                            .font(.title)
                            .clipShape(Circle())
                            .padding(.trailing)
                    }
                }
            }
        }
        .alert(isPresented: $showingPlaceDetails) {
            if isUnlocked {
            return Alert(title: Text(selectedPlace?.title ?? "Unknown"), message: Text(selectedPlace?.subtitle ?? "Missing place information."), primaryButton: .default(Text("OK")), secondaryButton: .default(Text("Edit")) {
                self.showingEditScreen = true
                })
            } else {
                return Alert(title: Text("Authentication Failed"), message: Text("Please authenticate to see your places"), dismissButton: .default(Text("ok")))
            }
        }
        .sheet(isPresented: $showingEditScreen, onDismiss: saveData) {
            if self.selectedPlace != nil {
                EditView(placemark: self.selectedPlace!)
            }
        }
        .actionSheet(isPresented: $showList) {
            ActionSheet(title: Text("My Places"), buttons: buttonsToList)
        }
    .onAppear(perform: authenticate)
            }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func loadData() {
        let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
        
        do {
            let data = try Data(contentsOf: filename)
            locations = try JSONDecoder().decode([CodableMKPointAnnotation].self, from: data)
        } catch {
            print("Unable to load saved data.")
        }
    }
   
    func saveData() {
        do {
            let filename = getDocumentsDirectory().appendingPathComponent("SavedPlaces")
            let data = try JSONEncoder().encode(self.locations)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            // this reason to TouchID, in info.plist to faceID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                        self.loadData()
                    } else {
                        self.showingPlaceDetails = true
                    }
                }
            }
        } else {
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
