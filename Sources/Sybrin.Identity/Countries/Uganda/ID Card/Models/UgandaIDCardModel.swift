//
//  UgandaIDCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2021/05/05.
//  Copyright © 2021 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class UgandaIDCardModel: IDCardModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case mrzLine1, mrzLine2, mrzLine3, issuingCountryCode, cardNumber, cardNumberCheckDigit, optionalData1, optionalData2, dateOfBirthCheckDigit, dateOfExpiry, dateOfExpiryCheckDigit, dateIssued, compositeCheckDigit, surname, names }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.4 }
    final override var CroppingTopOffset: CGFloat { return 1.3 }
    final override var CroppingWidthOffset: CGFloat { return 5.1 }
    final override var CroppingHeightOffset: CGFloat { return 3.3 }
    final override var CroppingBackLeftOffset: CGFloat { return 5.4 }
    final override var CroppingBackTopOffset: CGFloat { return 2.6 }
    final override var CroppingBackWidthOffset: CGFloat { return 12.8 }
    final override var CroppingBackHeightOffset: CGFloat { return 8.1 }
    
    // MARK: Internal Properties
    final var MRZLine1: String?
    final var MRZLine2: String?
    final var MRZLine3: String?
    
    final var IssuingCountryCode: String?
    final var CardNumber: String?
    final var CardNumberCheckDigit: Int?
    final var OptionalData1: String?
    final var OptionalData2: String?
    final var DateOfBirthCheckDigit: Int?
    final var DateOfExpiry: Date?
    final var DateOfExpiryCheckDigit: Int?
    final var DateIssued: Date?
    final var CompositeCheckDigit: Int?
    final var Surname: String?
    final var Names: String?
    
    // MARK: Public Properties
    @objc public final var mrzLine1: String? { get { return self.MRZLine1 } }
    @objc public final var mrzLine2: String? { get { return self.MRZLine2 } }
    @objc public final var mrzLine3: String? { get { return self.MRZLine3 } }
    
    @objc public final var issuingCountryCode: String? { get { return self.IssuingCountryCode } }
    @objc public final var cardNumber: String? { get { return self.CardNumber } }
    @objc public final var cardNumberCheckDigit: Int { get { return self.CardNumberCheckDigit ?? -1 } }
    @objc public final var optionalData1: String? { get { return self.OptionalData1 } }
    @objc public final var optionalData2: String? { get { return self.OptionalData2 } }
    @objc public final var dateOfBirthCheckDigit: Int { get { return self.DateOfBirthCheckDigit ?? -1 } }
    @objc public final var dateOfExpiry: Date? { get { return self.DateOfExpiry } }
    @objc public final var dateOfExpiryCheckDigit: Int { get { return self.DateOfExpiryCheckDigit ?? -1 } }
    @objc public final var dateIssued: Date? { get { return self.DateIssued } }
    @objc public final var compositeCheckDigit: Int { get { return self.CompositeCheckDigit ?? -1 } }
    @objc public final var surname: String? { get { return self.Surname } }
    @objc public final var names: String? { get { return self.Names } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mrzLine1, forKey: .mrzLine1)
        try container.encode(mrzLine2, forKey: .mrzLine2)
        try container.encode(mrzLine3, forKey: .mrzLine3)
        try container.encode(issuingCountryCode, forKey: .issuingCountryCode)
        try container.encode(cardNumber, forKey: .cardNumber)
        try container.encode(cardNumberCheckDigit, forKey: .cardNumberCheckDigit)
        try container.encode(optionalData1, forKey: .optionalData1)
        try container.encode(optionalData2, forKey: .optionalData2)
        try container.encode(dateOfBirthCheckDigit, forKey: .dateOfBirthCheckDigit)
        try container.encode(dateOfExpiry, forKey: .dateOfExpiry)
        try container.encode(dateOfExpiryCheckDigit, forKey: .dateOfExpiryCheckDigit)
        try container.encode(dateIssued, forKey: .dateIssued)
        try container.encode(compositeCheckDigit, forKey: .compositeCheckDigit)
        try container.encode(surname, forKey: .surname)
        try container.encode(names, forKey: .names)

        try super.encode(to: encoder)
    }

}
