//
//  PhilippinesSeafarerIdentificationRecordBookScanPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Armand Riley on 2021/07/22.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import Sybrin_Common
import AVFoundation
import UIKit

final class PhilippinesSeafarerIdentificationRecordBookScanPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    private final var LastFrame: CMSampleBuffer?
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // MARK: Overrided Methods
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        if Model == nil {
            LastFrame = buffer
            FaceDetection(from: buffer)
            if Model == nil {
                TextRecognition(from: buffer)
            }
        } else {
            Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
            Complete()
        }
        
        if Constants.isManualCapture == true {
            Constants.frontImage = LastFrame?.toUIImage(fixOrientation: true)
            Constants.isManualCapture = false
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
        guard let controller = Plan?.controller else { return }
        switch result {
            case .success(_):
            DispatchQueue.main.async {
                
                let _ = Constants.Backimage
                let imageView = UIView(frame: .zero) //UIImageView(image: image)
                imageView.backgroundColor = UIColor(hex: "#F5F5F5ff") //.lightGray
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.contentMode = .scaleToFill
                
                controller.CameraPreview.addSubview(imageView)
                
                controller.CameraPreview.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: controller.CameraPreview.leadingAnchor),
                    imageView.topAnchor.constraint(equalTo: controller.CameraPreview.topAnchor),
                    imageView.trailingAnchor.constraint(equalTo: controller.CameraPreview.trailingAnchor),
                    imageView.bottomAnchor.constraint(equalTo: controller.CameraPreview.bottomAnchor),
                ])
                
                CommonUI.loadingAnim(to: controller.CameraPreview)
                
                done()
            }
            case .failure(_):
                done()
        }
        
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
    }
    
}
