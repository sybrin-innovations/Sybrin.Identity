//
//  MozambiqueIDCardTD1Parser.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/04.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

final class MozambiqueIDCardTD1Parser: TraditionalTD1Parser {
    
    // MARK: Overrided Properties
    final override var Line1Regex: NSRegularExpression { get { return RegexConstants.Mozambique_TD1_MRZ_Line1 } }
    
    // MARK: Overrided Methods
    final override func ParseLine1(from line: String) {
        guard !Line1Parsed else { "Validation Failed: Line 1 Already Parsed".log(.ProtectedWarning); return }
        
        guard line.count == 30 else { "Validation Failed: Line 1 Length".log(.ProtectedWarning); return }
                
        guard Line1Regex.matches(line) else { "Validation Failed: Line 1 Regex".log(.ProtectedWarning); return }
        
        Model.DocumentType = line.substring(with: 0..<2).replacingOccurrences(of: "<", with: "")
        
        guard Model.DocumentType?.count ?? 0 > 0 else { "Parse Failed: Document Type".log(.ProtectedWarning); return }
        
        Model.IssuingCountryCode = line.substring(with: 2..<5)
        
        guard Model.IssuingCountryCode == Country.Mozambique.idCardCountryCode else { "Validation Failed: Issuing Country Code".log(.ProtectedWarning); return }
        
        Model.DocumentNumber = line.substring(with: 5..<14).replaceCommonCharactersWithNumbers()
        
        guard let documentNumber = Model.DocumentNumber else { "Parse Failed: Document Number".log(.ProtectedWarning); return }
        
        Model.DocumentNumberCheckDigit = Int(line.substring(with: 14..<15))
        
        guard let documentNumberCheckDigit = Model.DocumentNumberCheckDigit else { "Parse Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        guard CheckDigitValidator.GetCheckDigitUsingMRZAlgorithm(for: documentNumber) == documentNumberCheckDigit else { "Validation Failed: Document Number Check Digit".log(.ProtectedWarning); return }
        
        Model.OptionalData1 = line.substring(with: 15..<30)
        
        Line1 = line
        Model.MRZLine1 = Line1
        Line1Parsed = true
    }
    
}
