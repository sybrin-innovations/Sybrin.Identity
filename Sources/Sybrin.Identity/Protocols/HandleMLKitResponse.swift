//
//  HandleMLKitResponse.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/08/24.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import MLKit

protocol HandleMLKitResponse: AnyObject {
//    func handleTextRecognitionResult(_ result: Text)
    func handleFaceDetectionResult(_ result: [Face])
//    func handleBarcodeScanningResult(_ result: [Barcode])
    func handleError(_ error: Error)
}

extension HandleMLKitResponse {
//    func handleTextRecognitionResult(_ result: Text) { }
    func handleFaceDetectionResult(_ result: [Face]) { }
//    func handleBarcodeScanningResult(_ result: [Barcode]) { }
}
