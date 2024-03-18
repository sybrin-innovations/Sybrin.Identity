//
//  UgandaIDCardTD1Parser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/05.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

final class UgandaIDCardTD1Parser: TraditionalTD1Parser {
    
    // MARK: Overrided Properties
    final override var Line1Regex: NSRegularExpression { get { return RegexConstants.Uganda_TD1_MRZ_Line1 } }
    final override var Line2Regex: NSRegularExpression { get { return RegexConstants.Uganda_TD1_MRZ_Line2 } }
    
    // MARK: Overrided Methods
    final override func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
                
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
        
        guard Model.DocumentType?.count ?? 0 > 0 else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
        guard Model.IssuingCountryCode == Country.Uganda.idCardCountryCode else { "Validation Failed: Issuing Country Code".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = line.substring(with: 5..<14).replaceCommonCharactersWithNumbers()
        
        guard let documentNumber = Model.DocumentNumber else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
        Model.DocumentNumberCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Parse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: documentNumber) == documentNumberCheckDigit else { "Validation Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData1 = line.substring(with: 15..<30)
        
        let identityNumber = Model.OptionalData1?.trimmingCharacters(in: CharacterSet(charactersIn: "< ")) ?? ""
        
        guard RegexConstants.Uganda_IdentityNumber.matches(identityNumber) else { "Validation Failed: Identity Number (Optional Data 1) Regex".log(.ProtectedWarning); return }
        
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
        
        Model.NationalityCountryCode = line.substring(with: 15..<18)
        
        Model.OptionalData2 = line.substring(with: 18..<29)
        
        Model.CompositeCheckDigit = Int(line.substring(with: 29..<30))
        
        guard let compositeCheckDigit = Model.CompositeCheckDigit else { "Parse Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        guard let documentNumber = Model.DocumentNumber else { "Reparse Failed: Document Number".log(.ProtectedWarning); return }
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Reparse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        let optionalData1 = Model.OptionalData1 ?? ""
        
        let optionalData2 = Model.OptionalData2 ?? ""
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: "\(documentNumber)\(documentNumberCheckDigit)\(optionalData1)\(dateOfBirth)\(dateOfBirthCheckDigit)\(dateOfExpiry)\(dateOfExpiryCheckDigit)\(optionalData2)") == compositeCheckDigit else { "Validation Failed: Composite Check Digit".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = Model.DocumentNumber?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.OptionalData1 = Model.OptionalData1?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        Model.OptionalData2 = Model.OptionalData2?.trimmingCharacters(in: CharacterSet(charactersIn: "< "))
        
        guard RegexConstants.NumbersOnly.matches(Model.OptionalData2 ?? "") else { "Validation Failed: Date Issued (Optional Data 2) Regex".log(.ProtectedWarning); return }
        
        guard Model.OptionalData2?.count == 6 && Model.OptionalData2?.stringToDate(withFormat: "yyMMdd") != nil else { "Parse Failed: Date Issued (Optional Data 2)".log(.ProtectedWarning); return }
        
        Line2 = line
        Model.MRZLine2 = Line2
        Line2Parsed = true
    }
    
}
