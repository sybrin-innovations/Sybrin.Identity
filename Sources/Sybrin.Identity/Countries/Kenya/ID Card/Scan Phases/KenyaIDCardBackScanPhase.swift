////
////  KenyaIDCardBackScanPhase.swift
////  Sybrin.iOS.Identity
////
////  Created by Nico Celliers on 2020/10/07.
////  Copyright © 2020 Sybrin Systems. All rights reserved.
////
//
//import Sybrin_Common
//import AVFoundation
//////import MLKit
//
//final class KenyaIDCardBackScanPhase: ScanPhase<DocumentModel> {
//    
//    // MARK: Private Properties
//    private final var Face: Face?
//    private final var FaceFrameCount: Int?
//    private final var ModelFrameCount: Int?
//    private final var LastFrame: CMSampleBuffer?
//    private final var Parser = KenyaIDCardParser()
//    
//    // Notify User
//    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
//    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
//    
//    // Phase Variables
//    private final var PreviousPhaseAttemptFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private final let ThrottlePhaseAttemptByMilliseconds: Double = 1000
//    private final var PhaseAttempts = 0
//    private final let PhaseAttemptLimit = 20
//    private final var PausePhaseAttempt = !(SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification)
//    
//    // Validation
//    private final let ValidateFrontAndBack: Bool = SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification
//    
//    // MARK: Private Methods
//    private final func ValidateIdentityNumber(for currentIdentityNumber: String) -> Bool {
//        if let previousIdentityNumber = (PreviousModel as? KenyaIDCardModel)?.IdentityNumber {
//            return (currentIdentityNumber.contains(previousIdentityNumber))
//        } else {
//            return false
//        }
//    }
//    
//    // MARK: Overrided Methods
//    final override func PreProcessing(done: @escaping () -> Void) {
//        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
//        
//        DispatchQueue.main.async {
//            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
//            done()
//        }
//    }
//    
//    final override func ProcessFrame(buffer: CMSampleBuffer) {
//        guard !(PhaseAttemptLimit > 0 && PhaseAttempts > PhaseAttemptLimit) else {
//            Fail(with: .Timeout)
//            return
//        }
//        
//        if Face == nil || Model == nil || !(FaceFrameCount == ModelFrameCount) {
//            if Face == nil && Model != nil && ((ModelFrameCount ?? 0) < FrameCounter) {
//                Model = nil
//                ModelFrameCount = nil
//            }
//            if Model == nil && Face != nil && ((FaceFrameCount ?? 0) < FrameCounter) {
//                Face = nil
//                FaceFrameCount = nil
//            }
//            
//            LastFrame = buffer
//            if Face == nil && FaceFrameCount == nil {
//                FaceDetection(from: buffer)
//            }
//            if Model == nil && ModelFrameCount == nil {
//                TextRecognition(from: buffer)
//            }
//        } else if FaceFrameCount == ModelFrameCount {
//            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
//            Complete()
//        }
//        
//        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
//            PreviousPhaseAttemptFrameTime = currentTimeMs
//            
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                
//                if self.PhaseAttempts < self.PhaseAttemptLimit {
//                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: (self.PreviousModel as? KenyaIDCardModel)?.identityNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
//                } else {
//                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeExpired.stringValue, animationColor: .red)
//                }
//                
//                self.PhaseAttempts += 1
//            }
//        }
//        
//        // Notifying user if scanning is taking too long
//        if !(SybrinIdentity.shared.configuration?.enableHelpMessages ?? SybrinIdentityConfiguration.EnableHelpMessages) {
//            let currentTimeMs = Date().timeIntervalSince1970 * 1000
//            if (currentTimeMs - NotifyUserFrameTime) >= DelayNotifyUserEveryMilliseconds {
//                guard let controller = Plan?.controller else { return }
//                
//                controller.NotifyUser(WarningNotifyMessage, flashBorderColor: .orange, flashOverlayColor: nil)
//                NotifyUserFrameTime = currentTimeMs
//            }
//        }
//
//    }
//    
//    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
//        guard let controller = Plan?.controller else { return }
//        
//        switch result {
//            case .success(_):
//                guard let model = Model as? KenyaIDCardModel else { return }
//                guard let previousModel = PreviousModel as? KenyaIDCardModel else { return }
//                guard let frame = LastFrame else { return }
//                guard let face = Face else { return }
//                
//                model.DocumentImage = previousModel.DocumentImage
//                model.PortraitImage = previousModel.PortraitImage
//                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
//                
//                model.DocumentImagePath = previousModel.DocumentImagePath
//                model.PortraitImagePath = previousModel.PortraitImagePath
//                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
//                
//                "Cropping and processing image".log(.Debug)
//                
//                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
//                
//                let faceRect = SybrinIdentity.shared.configuration?.cameraPosition == .front ? face.frame.RotateRight(containerWidth: image.size.width) : face.frame.RotateLeft(containerHeight: image.size.height)
//                
//                let portraitImage = image.CropImage(faceRect, padding: 25)
//                let croppedDocumentImage = image.CropImage(image.GetCropRect(model.CroppingBackLeftOffset, model.CroppingBackTopOffset, model.CroppingBackWidthOffset, model.CroppingBackHeightOffset, faceRect))
//                
//                model.DocumentBackImage = image
//                model.PortraitBackImage = portraitImage
//                model.CroppedDocumentBackImage = croppedDocumentImage
//                
//                done()
//            case .failure(_):
//                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
//                    guard let self = self else { return }
//                    
//                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? KenyaIDCardModel)?.IdentityNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
//                    
//                    CommonUI.updateLabelText(to: NotifyMessage.ScanFrontCard.stringValue)
//                    CommonUI.updateSubLabelText(to: NotifyMessage.Empty.stringValue, animationColor: nil)
//                    
//                    IdentityUI.AnimateRotateCard(controller.CameraPreview, forward: false, completion: { _ in
//                        done()
//                    })
//                    
//                }
//        }
//        
//    }
//    
//    final override func ProcessFaceDetection(faces: [Face]) {
//        if faces.count >= 1 {
//            Face = faces.max(by: { a, b in a.frame.width < b.frame.width })
//            FaceFrameCount = FrameCounter
//            "Found Face".log(.Verbose)
//        }
//    }
//    
//    final override func ProcessTextRecognition(text: Text) {
//        guard text.text.count > 0 else { return }
//        
//        Parser.ParseBack(from: text) { [weak self] (model) in
//            guard let self = self else { return }
//            
//            if (self.ValidateFrontAndBack && self.ValidateIdentityNumber(for: model.IdentityNumber ?? "")) || !self.ValidateFrontAndBack {
//                "Found Model".log(.Verbose)
//                self.Model = model
//                self.ModelFrameCount = self.FrameCounter
//            }
//        }
//        
//    }
//    
//    final override func ResetData() {
//        let currentTimeMs = Date().timeIntervalSince1970 * 1000
//        
//        Face = nil
//        FaceFrameCount = nil
//        ModelFrameCount = nil
//        LastFrame = nil
//        
//        NotifyUserFrameTime = currentTimeMs
//        PreviousPhaseAttemptFrameTime = currentTimeMs
//        
//        PhaseAttempts = 0
//    }
//    
//}
