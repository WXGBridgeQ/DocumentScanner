//
//  TextRecognition.swift
//  DocumentScanner
//
//  Created by Screening Eagle MB4 on 14/3/21.
//

import Foundation
import Vision

struct TextRecognition {
    private let queue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated)

    func recognize(cgImage: CGImage, handler: @escaping (Result<String, Error>) -> Void) {
        queue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage)

            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    DispatchQueue.main.async {
                        handler(.failure(error))
                    }
                    return
                }
                let result = (request.results as? [VNRecognizedTextObservation])?.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n") ?? ""
                DispatchQueue.main.async {
                    handler(.success(result))
                }
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            do {
                try requestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            }
        }
    }
}
