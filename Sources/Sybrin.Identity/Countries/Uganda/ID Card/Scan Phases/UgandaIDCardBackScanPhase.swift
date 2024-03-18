//
//  UgandaIDCardBackScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/05.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_Common
import AVFoundation
import MLKit

final class UgandaIDCardBackScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var LastFrame: CMSampleBuffer?
    private final var Parser = UgandaIDCardParser()
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // Phase Variables
    private final var PreviousPhaseAttemptFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let ThrottlePhaseAttemptByMilliseconds: Double = 1000
    private final var PhaseAttempts = 0
    private final let PhaseAttemptLimit = 20
    private final var PausePhaseAttempt = !(SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification)
    
    // Validation
    private final let ValidateFrontAndBack: Bool = SybrinIdentity.shared.configuration?.enableMultiPhaseVerification ?? SybrinIdentityConfiguration.EnableMultiPhaseVerification
    
    // MARK: Private Methods
    private final func ValidateCardNumber(for currentCardNumber: String) -> Bool {
        if let previousCardNumber = (PreviousModel as? UgandaIDCardModel)?.CardNumber {
            return (currentCardNumber.contains(previousCardNumber))
        } else {
            return false
        }
    }
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
        
        DispatchQueue.main.async {
            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
            done()
        }
    }
    
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        guard !(PhaseAttemptLimit > 0 && PhaseAttempts > PhaseAttemptLimit) else {
            Fail(with: .Timeout)
            return
        }
        
        if Model == nil {
            LastFrame = buffer
            TextRecognition(from: buffer)
        } else {
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if !PausePhaseAttempt && PhaseAttemptLimit > 0 {
            let currentTimeMs = Date().timeIntervalSince1970 * 1000
            guard (currentTimeMs - PreviousPhaseAttemptFrameTime) >= ThrottlePhaseAttemptByMilliseconds else { return }
            PreviousPhaseAttemptFrameTime = currentTimeMs
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if self.PhaseAttempts < self.PhaseAttemptLimit {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeRemaining(topLine: (self.PreviousModel as? UgandaIDCardModel)?.cardNumber, timeRemaining: self.PhaseAttemptLimit - self.PhaseAttempts).stringValue, animationColor: nil)
                } else {
                    CommonUI.updateSubLabelText(to: NotifyMessage.TimeExpired.stringValue, animationColor: .red)
                }
                
                self.PhaseAttempts += 1
            }
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
        guard let controller = Plan?.controller else { return }
        
        switch result {
            case .success(_):
                guard let model = Model as? UgandaIDCardModel else { return }
                guard let previousModel = PreviousModel as? UgandaIDCardModel else { return }
                guard let frame = LastFrame else { return }
                
                model.DocumentImage = previousModel.DocumentImage
                model.PortraitImage = previousModel.PortraitImage
                model.CroppedDocumentImage = previousModel.CroppedDocumentImage
                
                model.DocumentImagePath = previousModel.DocumentImagePath
                model.PortraitImagePath = previousModel.PortraitImagePath
                model.CroppedDocumentImagePath = previousModel.CroppedDocumentImagePath
                
                "Cropping and processing image".log(.Debug)
                
                let image = UIImage.imageFromSampleBuffer(frame, fixOrientation: true)
                
                model.DocumentBackImage = image
                
                done()
            case .failure(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) { [weak self] in
                    guard let self = self else { return }
                    
                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? UgandaIDCardModel)?.IdentityNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
                    
                    CommonUI.updateLabelText(to: NotifyMessage.ScanFrontCard.stringValue)
                    CommonUI.updateSubLabelText(to: NotifyMessage.Empty.stringValue, animationColor: nil)
                    
                    IdentityUI.AnimateRotateCard(controller.CameraPreview, forward: false, completion: { _ in
                        done()
                    })
                    
                }
        }
        
    }
    
    final override func ProcessTextRecognition(text: Text) {
        guard text.text.count > 0 else { return }
        
        Parser.ParseBack(from: text) { [weak self] (model) in
            guard let self = self else { return }
            
            if (self.ValidateFrontAndBack && self.ValidateCardNumber(for: model.CardNumber ?? "")) || !self.ValidateFrontAndBack {
                "Found Model".log(.Verbose)
                self.Model = model
            }
        }
        
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
        PreviousPhaseAttemptFrameTime = currentTimeMs
        
        PhaseAttempts = 0
    }
    
}
