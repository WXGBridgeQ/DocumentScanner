//
//  TextPreviewView.swift
//  DocumentScanner
//
//  Created by Screening Eagle MB4 on 14/3/21.
//

import SwiftUI

struct TextPreviewView: View {
    let text: String

    var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: rightBarItem)
    }

    private var rightBarItem: some View {
        Button {
            UIPasteboard.general.string = text
        } label: {
            Label("Copy", systemImage: "doc.on.doc")
        }
    }
}

struct TextPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TextPreviewView(text:
"""
struct TextPreviewView: View {
    let text: String

    var body: some View {
        ScrollView {
            Text(text)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: rightBarItem)
    }

    private var rightBarItem: some View {
        Button {
            UIPasteboard.general.string = text
        } label: {
            Label("Copy", systemImage: "doc.on.doc")
        }
    }
}
"""
            )
        }
    }
}
