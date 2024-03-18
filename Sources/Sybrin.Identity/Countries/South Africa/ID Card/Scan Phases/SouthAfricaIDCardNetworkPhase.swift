//
//  SouthAfricaIDCardNetworkPhase.swift
//  Sybrin.iOS.Identity
//
//  Created by Rhulani Ndhlovu on 2023/10/15.
//  Copyright © 2023 Sybrin Systems. All rights reserved.
//

import Foundation
import Sybrin_Common
import UIKit
import AVFoundation
////import MLKit

class SouthAfricaIDCardNetworkPhase: ScanPhase<DocumentModel> {
    
    // MARK: Private Properties
    // **
    
    private final var LastFrame: CMSampleBuffer?
    private final var LastFrameImage: UIImage?
    
    private var Finished = false;
    
    // Notify User
    private final var NotifyUserFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let DelayNotifyUserEveryMilliseconds: Double = 10000
    private final let WarningNotifyMessage = NotifyMessage.Help.stringValue
    
    // Phase Variables
    private final var PreviousPhaseAttemptFrameTime: TimeInterval = Date().timeIntervalSince1970 * 1000
    private final let ThrottlePhaseAttemptByMilliseconds: Double = 1000
    
    
    private var nuModel: SouthAfricaIDCardModel?
    
    // MARK: Overrided Methods
    final override func PreProcessing(done: @escaping () -> Void) {
        
        NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
        
        PostAuditData() { [self] res in
            
            switch res {
            case .success(let auth):
                uploadImageToServer(auth: auth)
            case .failure(_):
                break
            }
            
        }
        
        DispatchQueue.main.async {
            CommonUI.updateLabelText(to: NotifyMessage.ScanBackCard.stringValue)
            done()
        }
    }
    
    
    
    final override func ProcessFrame(buffer: CMSampleBuffer) {
        
      if self.Finished {
          let model = PhilippinesIdentificationCardModel()
          
          self.Model = model
            NotifyUserFrameTime = Date().timeIntervalSince1970 * 1000
          
            Complete()
          Constants.isManualCapture = false
        } else {
            LastFrame = buffer
        }
        
    }
    
    
    final override func PostProcessing(for result: Result<Bool, ScanFailReason>, done: @escaping () -> Void) {
        guard let controller = Plan?.controller else { return }
        
        switch result {
            case .success(_):
            
            self.Model = nuModel
            
            DispatchQueue.main.async {
                done()
            }
            
            case .failure(_):
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    controller.NotifyUser(NotifyMessage.DetectionFailed(for: (self.PreviousModel as? PhilippinesIdentificationCardModel)?.IdentityNumber).stringValue, flashBorderColor: nil, flashOverlayColor: nil)
                    
                    CommonUI.updateLabelText(to: NotifyMessage.ScanFrontCard.stringValue)
                    CommonUI.updateSubLabelText(to: NotifyMessage.Empty.stringValue, animationColor: nil)
                    
                    IdentityUI.AnimateRotateCard(controller.CameraPreview, forward: false, completion: { _ in
                        done()
                    })
                    
                }
        }
        
    }
    
    
    
    override func ProcessTextRecognition() {
        
        self.Model = PhilippinesIdentificationCardModel();
        self.Finished = true
        return;
    
    }
    
    final override func ResetData() {
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        LastFrame = nil
        
        NotifyUserFrameTime = currentTimeMs
        PreviousPhaseAttemptFrameTime = currentTimeMs
        
    }
    
    func PostAuditData(completion: @escaping(Result<String, IdentityNetworkError>) -> Void) {
        
        let urlString = "https://soma.sybrin.com/api/Authentication/GetAuthToken"
        
        guard !urlString.isEmpty else{
            return
        }
        
        guard let endpoint: URL = URL(string: urlString) else {
            completion(.failure(.NetworkError(error: .BadRequest)))
            return
        }
        
        var request: URLRequest = URLRequest(url: endpoint)
        
        request.httpMethod = "POST"
        
        let orc_token = Constants.orchestrationAPIKey
        
        request.addValue(orc_token ?? "4TCwugAK2AW3mphu+F5RovGmOEj5oM63iQnUlHyVJtRDohz5qULCOc6GhnyP0gi9UKPC6M9ta/QZIPHHdgGwiTCnBsTIN7lAL8+djeMsDFt23e3BfjRmDQ7n1nJPnwA25Pdwlcxyv4Q5BD0khUzCJVM2vkli1gy7FOvJJ/IN72Qu/W8DVXn3dvulMwRH5/fZYYX8Fq+LGimXUmEc5QpH9dWYgO6489bxczmWyvzyEfOJZASuIkCpABcaoAakcEzDGnVo7GYaqnUAHM3pb2VFpGkObTO01mL8t71+MUX7Rm/2DKYZMbnr2Ep1DWfs2qsrGYq1ffYWoof5N6AAvIoYAgmq78OemK0efUO3/EIB0fzAWg2F36BMYaI4sLmTmp76BrmNKhsPWM3TZjXYj9xNJoFV6j0SVtYVNsa4R8BCWDm3N2wIn6EJ5uwTYsIJQFZtZjjQVNY/hRulKHbD+ZbkB5xwOPuhrAbvrMFGyo4ZYNw=", forHTTPHeaderField: "APIKey")
        request.addValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let Body: [String: Any?] = [
            "ObjectID": "SybrinIdentitySDKAuditingModel",
            "Platform": "iOS"
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: Body)
        
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if let token = responseJSON["AuthToken"] {
                        completion(.success("\(token)"))
                    }
                }
            }

            task.resume()
        
        } catch {
            "Request body parse error".log(.ProtectedError)
            "Error: \(error.localizedDescription)".log(.Verbose)
            completion(.failure(.NetworkError(error: .BadRequest)))
        }
    }
    
    func createDataBody(media: [Media]?, boundary: String) -> Data {
       let lineBreak = "\r\n"
       var body = Data()
       if let media = media {
          for photo in media {
             body.append("--\(boundary + lineBreak)")
             body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
             body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
             body.append(photo.data)
             body.append(lineBreak)
          }
       }
       body.append("--\(boundary)--\(lineBreak)")
       return body
    }
    
    func uploadImageToServer(auth: String) {
        
        guard let mediaImage = Media(withImage: Constants.frontImage!, forKey: "image", name: "FrontImage") else { return }
        guard let mediaImage2 = Media(withImage: Constants.Backimage!, forKey: "image", name: "BackImage") else { return }
        let orch_base_url = Constants.orchestrationURL
       guard let url = URL(string: "\(orch_base_url ?? "https://soma.sybrin.com/")" + "api/DocumentCapture/ExtractData") else { return }
       var request = URLRequest(url: url)
        
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
        request.setValue("IDCARD", forHTTPHeaderField: "DocumentType")
        request.setValue("ZAF", forHTTPHeaderField: "CountryCode")
        request.setValue("true", forHTTPHeaderField: "UseV2")
        request.setValue("true", forHTTPHeaderField: "UseSegmentationBeforeOCR")
        
       request.httpMethod = "POST"
        
       let boundary = generateBoundary()
       //set content type
       request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
       let dataBody = createDataBody(media: [mediaImage, mediaImage2], boundary: boundary)
       request.httpBody = dataBody
       let session = URLSession.shared
       session.dataTask(with: request) { (data, response, error) in
        
          if let data = data {
             do {
                 
                 let json = try JSONDecoder().decode(SAIDCardResponseModel.self, from: data)
                 
                 let model = SouthAfricaIDCardModel();
                 
                 if let _extracted = json.ExtractedSAIDData?.utf8 {
                     let extracted = try JSONDecoder().decode(ExtractedSAIDData.self, from: Data(_extracted))
                     
                     model.IdentityNumber = extracted.IdentityNumber
                     
                     if (extracted.Surname?.rangeOfCharacter(from: NSCharacterSet.decimalDigits) == nil) {
                         model.Surname = extracted.Surname
                         
                     }
                     
                     if (extracted.Names?.rangeOfCharacter(from: NSCharacterSet.decimalDigits) == nil) {
                         model.Names = extracted.Names
                         
                     }
                     
                     
                     
                     model.IdentityNumber = extracted.IdentityNumber
                     //model.IdentityNumberADigit = extracted.IdentityNumberADigit
//                     model.IdentityNumberCheckDigit = extracted.IdentityNumberCheckDigit
//                     model.DateOfBirthCheckDigit = extracted.DateOfBirthCheckDigit
//                     model.IdentityNumberSex = extracted.IdentityNumberSex
//                     model.BackImageSecurityCheckSuccess = extracted.BackImageSecurityCheckSuccess
//                     model.DocumentValidationType = extracted.DocumentValidationType
//                     model.DocumentValidationStatus = extracted.DocumentValidationStatus
//                     model.Status = extracted.Status
                     model.CountryOfBirth = extracted.CountryOfBirth
//                     model.IdentityNumberCitizenship = extracted.IdentityNumberCitizenship
//                     model.IdentityNumberDateOfBirth = extracted.IdentityNumberDateOfBirth
                     
//                     if (extracted.Sex == "F") {
//                         model.Sex =  Sex.Female
//                     } else if (extracted.Sex == "M") {
//                         model.Sex =  Sex.Male
//                     }
//
//                     if (extracted.Sex?.lowercased() == "female") {
//                         model.Sex =  Sex.Female
//                     } else if (extracted.Sex?.lowercased() == "male") {
//                         model.Sex =  Sex.Male
//                     }
                     
                     if let stringImage = json.FrontImage {
                         if let frontImage = convertBase64ToImage(imageString: stringImage) {
                             model.DocumentImage = frontImage.fixOrientation(to: .up)
                         }
                     }
                     
                     if let stringImage = json.BackImage {
                         if let backImage = convertBase64ToImage(imageString: stringImage) {
                             model.DocumentBackImage = backImage.fixOrientation(to: .up)
                         }
                     }
                     
//                     if let ex = extracted.FaceDetection {
//                         var i = 0
//                         while i < ex.count {
//
//                             if let img = ex[i].FaceImage {
//
//                                 model.PortraitImage = convertBase64ToImage(imageString: img)?.fixOrientation(to: .up)
//                             }
//
//                             i = i + 1
//                         }
//                     }
                     
                     if let wordConfidence = extracted.WordConfidenceResults {
                         let _data: Data? = wordConfidence.data(using: .utf8)
                         
                         do {
                             if let wordConfidence: Dictionary<String, Any> = try JSONSerialization.jsonObject(with: _data ?? Data(), options: []) as? Dictionary<String, Any> {
                                 model.WordConfidenceResults = wordConfidence
                             }
                             
                         } catch {
                             
                         }
                     }
                 }
                 
                 
                 self.nuModel = model
                 
                 self.Finished = true
                 
             } catch {
                 
             }
          }
       }.resume()
    }
}
