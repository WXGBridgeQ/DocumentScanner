//
//  ImagePreviewView.swift
//  DocumentScanner
//
//  Created by Screening Eagle MB4 on 14/3/21.
//

import SwiftUI

struct ImagePreviewView: View {
    let image: UIImage

    @State private var isRecognizing = false
    @State private var isPresentedResult = false
    @State private var recognizedResult = ""

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            if isRecognizing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                    .scaleEffect(1.5)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: rightBarItem)
        .sheet(isPresented: $isPresentedResult) {
            NavigationView {
                TextPreviewView(text: recognizedResult)
            }
        }
    }

    private var rightBarItem: some View {
        HStack {
            Button(action: recognize) {
                Label("Recognize", systemImage: "doc.text.magnifyingglass")
            }
            Divider()
            Button(action: save) {
                Label("Save", systemImage: "photo.on.rectangle.angled")
            }
        }
    }

    private func recognize() {
        guard let cgImage = image.cgImage else { return }
        isRecognizing = true
        TextRecognition().recognize(cgImage: cgImage) { result in
            isRecognizing = false
            switch result {
            case .success(let text):
                recognizedResult = text
                isPresentedResult = true
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func save() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}

struct ImagePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImagePreviewView(image: UIImage(named: "1")!)
        }
    }
}
