//
//  MalawiPassportScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/03.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_Common
import AVFoundation
//import MLKit

final class MalawiPassportScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var Face: Face?
    private final var LastFrame: CMSampleBuffer?
    private final var Parser = MalawiPassportParser()
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // MARK: Overrided Methods
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        if Face == nil || Model == nil {
            LastFrame = buffer
            FaceDetection(from: buffer)
            if Model == nil {
                TextRecognition(from: buffer)
            }
        } else {
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        // Notifying user if scanning is taking too long
        if !(SybrinIdentity.shared.configuration?.enableHelpMessages ?? SybrinIdentityConfiguration.EnableHelpMessages) {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            if (currentTimeMs - NotifyUserFrameTime) >= DelayNotifyUserEveryMilliseconds {
                guard let controller = Plan?.controller else { return }
                
                controller.NotifyUser(WarningNotifyMessage, flashBorderColor: .orange, flashOverlayColor: nil)
                NotifyUserFrameTime = currentTimeMs
            }
        }
        
    }
    
    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        
        switch result {
            case .success(_):
                guard let model = Model as? MalawiPassportModel else { return }
                guard let frame = LastFrame else { return }
                guard let face = Face else { return }
                
                "Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
                
                let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? face.frame.RotateRight(containerWidth: image.size.width) : face.frame.RotateLeft(containerHeight: image.size.height)
                
                let portraitImage = image.CropImage(faceRect, padding: 25)
                let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingLeftOffset, model.CroppingTopOffset, model.CroppingWidthOffset, model.CroppingHeightOffset, faceRect))
                
                model.DocumentImage = image
                model.PortraitImage = portraitImage
                model.CroppedDocumentImage = croppedDocumentImage
                
                done()
            case .failure(_):
                done()
        }
        
    }
    
    final override func ProcessFaceDetection(faces: [Face]) {
        if faces.count >= 1 {
            Face = faces[0]
            "Found Face".log(.Verbose)
        }
    }
    
    final override func ProcessTextRecognition(text: Text) {
        guard text.text.count > 0 else { return }
        
        Parser.Parse(from: text) { [weak self] (model) in
            guard let self = self else { return }
            
            "Found Model".log(.Verbose)
            self.Model = model
        }
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        Face = nil
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
    }
    
}
