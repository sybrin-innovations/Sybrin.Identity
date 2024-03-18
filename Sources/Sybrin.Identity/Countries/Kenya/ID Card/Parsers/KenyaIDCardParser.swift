////
////  KenyaIDCardParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Nico Celliers on 2020/10/07.
////  Copyright © 2020 Sybrin Systems. All rights reserved.
////
//
//////import MLKit
//
//struct KenyaIDCardParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = KenyaIDCardTD1Parser()
//    
//    // Resetting Model
//    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private let ResetEveryMilliseconds: Double = 10000
//    
//    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: KenyaIDCardModel) -> Void) {
//        let model = KenyaIDCardModel()
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                if line.text.count != 8 {
//                    continue inner
//                }
//                if (RegexConstants.Kenya_IdentityNumber.matches(line.text)) {
//                    model.IdentityNumber = line.text
//                    success(model)
//                    break outer
//                }
//            }
//        }
//    }
//    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: KenyaIDCardModel) -> Void) {
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                
//                // Resetting model if needed
//                resetCheck: if ResetEveryMilliseconds >= 0 {
//                    let currentTimeMs = Date().timeIntervalSince1970 * 1000
//                    guard (currentTimeMs - PreviousResetTime) >= ResetEveryMilliseconds else { break resetCheck }
//                    PreviousResetTime = currentTimeMs
//
//                    Reset()
//                }
//                
//                let lineText = line.text.replacingOccurrences(of: " ", with: "").fixMRZGarbage()
//                
//                if (lineText.count == 30 && Parser.Line1Regex.matches(lineText) && !Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed) {
//                    Parser.ParseLine1(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line2Regex.matches(lineText) && Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1) {
//                    Parser.ParseLine2(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line3Regex.matches(lineText) && Parser.Line1Parsed && Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1 && lineText != Parser.Line2) {
//                    Parser.ParseLine3(from: lineText)
//                    break outer
//                }
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed && Parser.Line3Parsed, let model = TD1ModelToKenyaIDCardModel(Parser.Model) {
//            success(model)
//            Reset()
//        }
//        
//    }
//    
//    // MARK: Private Methods
//    private func Reset() {
//        Parser.Reset()
//    }
//    
//    private func TD1ModelToKenyaIDCardModel(_ td1Model: TD1Model) -> KenyaIDCardModel? {
//        let model = KenyaIDCardModel()
//        
//        model.MRZLine1 = td1Model.MRZLine1
//        model.MRZLine2 = td1Model.MRZLine2
//        model.MRZLine3 = td1Model.MRZLine3
//        
//        model.SerialNumber = td1Model.DocumentNumber
//        model.SerialNumberCheckDigit = td1Model.DocumentNumberCheckDigit
//        model.OptionalData1 = td1Model.OptionalData1
//        model.OptionalData2 = td1Model.OptionalData2
//        
//        model.Nationality = Country.Kenya.idCardCountryCode
//        model.DateOfBirth = td1Model.DateOfBirth
//        model.DateOfBirthCheckDigit = td1Model.DateOfBirthCheckDigit
//        model.Sex = td1Model.Sex
//        model.DateOfExpiry = td1Model.DateOfExpiry
//        model.DateOfExpiryCheckDigit = td1Model.DateOfExpiryCheckDigit
//        model.IdentityNumber = td1Model.OptionalData2?.substring(with: 3..<11)
//        model.CompositeCheckDigit = td1Model.CompositeCheckDigit
//        
//        model.FullName = td1Model.Names
//        
//        return model
//    }
//    
//}
