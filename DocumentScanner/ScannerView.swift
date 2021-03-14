//
//  ScannerView.swift
//  DocumentScanner
//
//  Created by Screening Eagle MB4 on 14/3/21.
//

import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    let didFinish: (Result<[UIImage], Error>) -> Void
    let didCancel: () -> Void

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = context.coordinator
        return scanner
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) { }

    final class Coordinator: NSObject {
        let scannerView: ScannerView

        init(with scannerView: ScannerView) {
            self.scannerView = scannerView
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(with: self) }
}

extension ScannerView.Coordinator: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let scannedImages = (0 ..< scan.pageCount).map { scan.imageOfPage(at: $0) }
        scannerView.didFinish(.success(scannedImages))
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        scannerView.didCancel()
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        scannerView.didFinish(.failure(error))
    }
}
