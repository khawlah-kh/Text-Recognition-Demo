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
    let uiImage = UIImage(named: "Image2")
    var body: some View {
        VStack{
            Text("Text Recognition Example")
                .padding()
            Image(uiImage: uiImage!)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            
            Text(recognisedText)
                .font(.title2)
                .padding()
            
        }.onAppear {
            recognizeText (image: uiImage)
        }
       
    }
    
    
    private func recognizeText(image : UIImage?){
       
        guard let cgImage = image?.cgImage else{
           
            return}
      //  to recognise a text :
        //Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
       
        //Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],error == nil else {
                return}
            let text = observations.compactMap { $0.topCandidates(1).first?.string
            }.joined(separator: " ")
            DispatchQueue.main.async {
                self.recognisedText = text

            }
           
        }
        //Process Request
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
