//
//  ContentView.swift
//  Shared
//
//  Created by khawlah khalid on 19/05/2022.
//

import SwiftUI
import Vision
struct ContentView: View {
    
    @State var recognisedText = ""
    @State var isShowingImagePicker = false
    @State var selectedUIImage : UIImage?
    
    var body: some View {
        VStack{
            Text("Text Recognition Example")
                .font(.title)
                .bold()
                .padding()
            
            Button {
                self.isShowingImagePicker.toggle()
            } label: {
                Text("Select an image 📷")
                    .font(.title3)
                    .bold()
                    .padding()
            }

            if selectedUIImage != nil{
                Image(uiImage: selectedUIImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            }
           
            Text(recognisedText)
                .font(.title2)
                .padding()
            
            Spacer()
            
        }
        .sheet(isPresented: $isShowingImagePicker) {
            self.loadAndRecognize()
        } content: {
            ImagePicker(image:$selectedUIImage)
        }
       
    }
    
    func loadAndRecognize(){
        guard let selectedUIImage=selectedUIImage else {return}
        recognizeText (image: selectedUIImage)
    }
    
    
    private func recognizeText(image : UIImage?){
        guard let cgImage = image?.cgImage else{return}
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
       
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],error == nil else {
                return}
            let text = observations.compactMap { $0.topCandidates(1).first?.string
            }.joined(separator: " ")
            DispatchQueue.main.async {
                self.recognisedText = text
            }
        }
        
        do{ try handler.perform([request]) }
        catch{ print(error) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
