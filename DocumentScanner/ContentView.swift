//
//  ContentView.swift
//  DocumentScanner
//
//  Created by Screening Eagle MB4 on 14/3/21.
//

import SwiftUI

struct ContentView: View {
    @State private var scannedImages = [UIImage]()
    @State private var isPresentedScanner = false

    private var isEmptyContent: Bool { scannedImages.isEmpty }

    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Doc Scanner")
                .navigationBarItems(trailing: rightBarItem)
        }.sheet(isPresented: $isPresentedScanner) {
            scannerView
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if isEmptyContent {
            scanButton
                .font(.largeTitle)
        } else {
            ScrollView {
                GeometryReader { geometry in
                    let width = geometry.size.width * 0.5 - 24
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(scannedImages, id: \.self) { image in
                            NavigationLink(destination: ImagePreviewView(image: image)) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width)
                                    .clipped()
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    @ViewBuilder
    private var rightBarItem: some View {
        if !isEmptyContent {
            scanButton
        }
    }

    private var scanButton: some View {
        Button {
            if isPresentedScanner { return }
            isPresentedScanner = true
        } label: {
            Label(isEmptyContent ? "Scan Now" : "Scan", systemImage: "doc.text.viewfinder")
        }
    }

    private var scannerView: some View {
        ScannerView { result in
            switch result {
            case .success(let images):
                scannedImages.append(contentsOf: images)
            case .failure(let error):
                print(error.localizedDescription)
            }
            isPresentedScanner = false
        } didCancel: {
            isPresentedScanner = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
