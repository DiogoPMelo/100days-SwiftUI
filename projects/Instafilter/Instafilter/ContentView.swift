//
//  ContentView.swift
//  Instafilter
//
//  Created by Diogo Melo on 12/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var hasIntensity = false
    @State private var filterIntensity = 0.5
    @State private var hasRadius = false
    @State private var radiusIntensity = 0.5
    @State private var hasScale = false
    @State private var scaleIntensity = 0.5
    
    @State private var showingImagePicker = false
    @State private var showingFilterSheet = false
    @State private var showingErrorSavingAlert = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var processedImage: UIImage?

    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()
    
    @State private var cantSee = ""
    
    var filterName: String {
        let name = currentFilter.name
                let r = name.index(name.startIndex, offsetBy: 2)..<name.endIndex
        
        let result = name[r]
        return String(result)
    }
    
    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
        },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
        }
        )
        let radius = Binding<Double>(
            get: {
                self.radiusIntensity
        },
            set: {
                self.radiusIntensity = $0
                self.applyProcessing()
        }
        )
        let scale = Binding<Double>(
            get: {
                self.scaleIntensity
        },
            set: {
                self.scaleIntensity = $0
                self.applyProcessing()
        }
        )
        
        return NavigationView {
            VStack {
                Text("\(filterName): \(cantSee)")
                
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                HStack {
                    if hasIntensity {
                    Text("Intensity")
                    Slider(value: intensity)
                    }
                    if hasRadius {
                        Text("Radius")
                        Slider(value: radius)
                    }
                    if hasScale {
                        Text("Scale")
                        Slider(value: scale)
                    }
                }.padding(.vertical)
                
                HStack {
                    Button("Change \(filterName) Filter") {
                        self.showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard let processedImage = self.processedImage else { return }
                        
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            print("Successfully saved photo!")
                        }
                        
                        imageSaver.errorHandler = {
                            print("Error saving photo: \($0.localizedDescription)")
                            self.showingErrorSavingAlert = true
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }.disabled(image == nil)
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .alert(isPresented: $showingErrorSavingAlert) {
                Alert(title: Text("Error saving image"),
                      dismissButton: .default(Text("ok")))
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                    .cancel()
                ])
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {
            hasIntensity = true
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        } else {
            hasIntensity = false
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            hasRadius = true
            currentFilter.setValue(radiusIntensity * 200, forKey: kCIInputRadiusKey)
        } else {
            hasRadius = false
        }
        if inputKeys.contains(kCIInputScaleKey) {
            hasScale = true
            currentFilter.setValue(scaleIntensity * 10, forKey: kCIInputScaleKey)
        } else {
            hasScale = false
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
                processedImage = uiImage
            cantSee = "filtering \(filterIntensity)%"
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
                loadImage()
    }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
