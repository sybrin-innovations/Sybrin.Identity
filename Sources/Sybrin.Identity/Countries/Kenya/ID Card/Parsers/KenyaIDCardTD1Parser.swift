//
//  KenyaIDCardTD1Parser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/07.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

final class KenyaIDCardTD1Parser: TraditionalTD1Parser {
    
    // MARK: Overrided Properties
    final override var Line2Regex: NSRegularExpression { get { return RegexConstants.Kenya_TD1_MRZ_Line2 } }
    
    // MARK: Overrided Methods
    final override func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
                
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
        
        guard Model.DocumentType?.count ?? 0 > 0 && Model.DocumentType == "ID" else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
        guard Model.IssuingCountryCode == Country.Kenya.idCardCountryCode else { "Validation Failed: Issuing Country Code".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = line.substring(with: 5..<14)
        
        guard let documentNumber = Model.DocumentNumber else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
        Model.DocumentNumberCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Parse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: documentNumber) == documentNumberCheckDigit else { "Validation Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData1 = line.substring(with: 15..<30)
        
        Line1 = line
        Model.MRZLine1 = Line1
        Line1Parsed = true
    }
    
    final override func ParseLine2(from line: String) {
        guard !Line2Parsed else { "Validation Failed: Line 2 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 2 Length".log(.ProtectedWarning); return }
                
        guard Line2Regex.matches(line) else { "Validation Failed: Line 2 Regex".log(.ProtectedWarning); return }
        
        Model.DateOfBirth = line.substring(with: 0..<6).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfBirth = Model.DateOfBirth?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Birth".log(.ProtectedWarning); return }
        
        Model.DateOfBirthCheckDigit = Int(line.substring(with: 6..<7))
        
        guard let dateOfBirthCheckDigit = Model.DateOfBirthCheckDigit else { "Parse Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfBirth) == dateOfBirthCheckDigit else { "Validation Failed: Date Of Birth Check Digit".log(.ProtectedWarning); return }
        
        Model.Sex = line.substring(with: 7..<8) == "M" ? Sex(rawValue: 0) : Sex(rawValue: 1)
        
        Model.DateOfExpiry = line.substring(with: 8..<14).stringToDate(withFormat: "yyMMdd")
        
        guard let dateOfExpiry = Model.DateOfExpiry?.dateToString(withFormat: "yyMMdd") else { "Parse Failed: Date Of Expiry".log(.ProtectedWarning); return }
        
        Model.DateOfExpiryCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let dateOfExpiryCheckDigit = Model.DateOfExpiryCheckDigit else { "Parse Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: dateOfExpiry) == dateOfExpiryCheckDigit else { "Validation Failed: Date Of Expiry Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData2 = line.substring(with: 15..<29)
        
        Model.CompositeCheckDigit = Int(line.substring(with: 29..<30))
        
        guard let compositeCheckDigit = Model.CompositeCheckDigit else { "Parse Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        guard let documentNumber = Model.DocumentNumber else { "Reparse Failed: Document Number".log(.ProtectedWarning); return }
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Reparse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        let optionalData1 = Model.OptionalData1 ?? ""
        
        let optionalData2 = Model.OptionalData2 ?? ""
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: "\(documentNumber)\(documentNumberCheckDigit)\(optionalData1)\(dateOfBirth)\(dateOfBirthCheckDigit)\(dateOfExpiry)\(dateOfExpiryCheckDigit)\(optionalData2)") == compositeCheckDigit else { "Validation Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = Model.DocumentNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))

        Line2 = line
        Model.MRZLine2 = Line2
        Line2Parsed = true
    }
    
    final override func ParseLine3(from line: String) {
        guard !Line3Parsed else { "Validation Failed: Line 3 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 3 Length".log(.ProtectedWarning); return }
                
        guard Line3Regex.matches(line) else { "Validation Failed: Line 3 Regex".log(.ProtectedWarning); return }
        
        guard RegexConstants.NoNumbers.matches(line) else { "Validation Failed: Name Regex".log(.ProtectedWarning); return }
        
        Model.Names = line.replacingOccurrences(of: "<", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        
        Line3 = line
        Model.MRZLine3 = Line3
        Line3Parsed = true
    }
}
