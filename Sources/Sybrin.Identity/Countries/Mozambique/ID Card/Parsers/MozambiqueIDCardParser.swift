////
////  MozambiqueIDCardParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Nico Celliers on 2021/05/03.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
//
//////import MLKit
//
//struct MozambiqueIDCardParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = MozambiqueIDCardTD1Parser()
//    
//    // Resetting Model
//    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private let ResetEveryMilliseconds: Double = 10000
//    
//    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: MozambiqueIDCardModel) -> Void) {
//        let model = MozambiqueIDCardModel()
//        
//        outer: for block in result.blocks {
//            inner: for line in block.lines {
//                guard line.text.contains("N") else { continue inner }
//                
//                let lineText = String(line.text.replacingOccurrences(of: " ", with: "").suffix(13))
//                
//                if (RegexConstants.Mozambique_IdentityNumber.matches(lineText)) {
//                    model.IdentityNumber = lineText
//                    success(model)
//                    break outer
//                }
//            }
//        }
//    }
//    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: MozambiqueIDCardModel) -> Void) {
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
//                if (lineText.count == 30 && !Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed) {
//                    guard Parser.Line1Regex.matches(lineText) else { continue inner }
//                    Parser.ParseLine1(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line1Parsed && !Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1) {
//                    guard Parser.Line2Regex.matches(lineText) else { continue inner }
//                    Parser.ParseLine2(from: lineText)
//                } else if (lineText.count == 30 && Parser.Line1Parsed && Parser.Line2Parsed && !Parser.Line3Parsed && lineText != Parser.Line1 && lineText != Parser.Line2) {
//                    guard Parser.Line3Regex.matches(lineText) else { continue inner }
//                    Parser.ParseLine3(from: lineText)
//                    break outer
//                }
//            }
//        }
//    
//        if Parser.Line1Parsed && Parser.Line2Parsed && Parser.Line3Parsed, let model = TD1ModelToMozambiqueIDCardModel(Parser.Model) {
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
//    private func TD1ModelToMozambiqueIDCardModel(_ td1Model: TD1Model) -> MozambiqueIDCardModel? {
//        let model = MozambiqueIDCardModel()
//        
//        guard td1Model.OptionalData2?.count == 9 else { return nil }
//        
//        model.MRZLine1 = td1Model.MRZLine1
//        model.MRZLine2 = td1Model.MRZLine2
//        model.MRZLine3 = td1Model.MRZLine3
//
//        model.IssuingCountryCode = td1Model.IssuingCountryCode
//        model.IdentityNumber = "\(td1Model.OptionalData2?.substring(with: 4..<8) ?? "")\(td1Model.DocumentNumber ?? "")\(td1Model.OptionalData2?.substring(with: 8..<9) ?? "")"
//        model.IdentityNumberCheckDigit = td1Model.DocumentNumberCheckDigit
//        model.OptionalData1 = td1Model.OptionalData1
//        
//        model.DateOfBirth = td1Model.DateOfBirth
//        model.DateOfBirthCheckDigit = td1Model.DateOfBirthCheckDigit
//        model.Sex = td1Model.Sex
//        model.DateOfExpiry = td1Model.DateOfExpiry
//        model.DateOfExpiryCheckDigit = td1Model.DateOfExpiryCheckDigit
//        model.Nationality = td1Model.NationalityCountryCode
//        model.OptionalData2 = td1Model.OptionalData2
//        model.CompositeCheckDigit = td1Model.CompositeCheckDigit
//        
//        model.Surname = td1Model.Surname
//        model.Names = td1Model.Names
//        
//        return model
//    }
//    
//}
