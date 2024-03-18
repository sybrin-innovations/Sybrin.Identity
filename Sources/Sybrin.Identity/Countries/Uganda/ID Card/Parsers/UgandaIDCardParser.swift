////
////  UgandaIDCardParser.swift
////  Sybrin.iOS.Identity
////
////  Created by Nico Celliers on 2021/05/05.
////  Copyright © 2021 Sybrin Systems. All rights reserved.
////
//
////import MLKit
//
//struct UgandaIDCardParser {
//    
//    // MARK: Private Properties
//    // Parser
//    private let Parser = UgandaIDCardTD1Parser()
//    
//    // Resetting Model
//    private var PreviousResetTime: TimeInterval = Date().timeIntervalSince1970 * 1000
//    private let ResetEveryMilliseconds: Double = 10000
//    
//    // MARK: Internal Methods
//    func ParseFront(from result: Text, success: @escaping (_ model: UgandaIDCardModel) -> Void) {
//        let model = UgandaIDCardModel()
//        
//        let sybrinItemGroup = MLKitHelper.BlocksToSybrinItemGroup(result.blocks)
//        
//        // Finding Card Number
//        let potentialMatches = sybrinItemGroup.Lines.filter { item in
//            let itemText = item.Text.replaceCommonCharactersWithLetters().lowercased().replacingOccurrences(of: " ", with: "")
//            return (itemText.contains("cardno"))
//        }
//        
//        search: for potentialMatch in potentialMatches {
//            guard let elementBelow = MLKitHelper.GetClosestItemBelow(from: potentialMatch, items: sybrinItemGroup.Elements, aligned: .Left) else { continue search }
//            
//            let elementBelowText = elementBelow.Text.replaceCommonCharactersWithNumbers()
//            
//            guard elementBelowText.count == 9 else { continue search }
//            
//            guard RegexConstants.NumbersOnly.matches(elementBelowText) else { continue search }
//            
//            model.CardNumber = elementBelowText
//            break search
//        }
//        
//        if model.CardNumber != nil {
//            success(model)
//            Reset()
//        }
//        
//    }
//    
//    mutating func ParseBack(from result: Text, success: @escaping (_ model: UgandaIDCardModel) -> Void) {
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
//        if Parser.Line1Parsed && Parser.Line2Parsed && Parser.Line3Parsed, let model = TD1ModelToUgandaIDCardModel(Parser.Model) {
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
//    private func TD1ModelToUgandaIDCardModel(_ td1Model: TD1Model) -> UgandaIDCardModel? {
//        let model = UgandaIDCardModel()
//        
//        model.MRZLine1 = td1Model.MRZLine1
//        model.MRZLine2 = td1Model.MRZLine2
//        model.MRZLine3 = td1Model.MRZLine3
//
//        model.IssuingCountryCode = td1Model.IssuingCountryCode
//        model.CardNumber = td1Model.DocumentNumber
//        model.CardNumberCheckDigit = td1Model.DocumentNumberCheckDigit
//        model.IdentityNumber = td1Model.OptionalData1
//        model.OptionalData1 = td1Model.OptionalData1
//        
//        model.DateOfBirth = td1Model.DateOfBirth
//        model.DateOfBirthCheckDigit = td1Model.DateOfBirthCheckDigit
//        model.Sex = td1Model.Sex
//        model.DateOfExpiry = td1Model.DateOfExpiry
//        model.DateOfExpiryCheckDigit = td1Model.DateOfExpiryCheckDigit
//        model.Nationality = td1Model.NationalityCountryCode
//        model.DateIssued = td1Model.OptionalData2?.stringToDate(withFormat: "yyMMdd")
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
