//
//  ZimbabwePassportModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/08.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class ZimbabwePassportModel: PassportModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case mrzLine1, mrzLine2, passportNumberCheckDigit, dateOfBirthCheckDigit, dateOfExpiryCheckDigit, identityNumber, identityNumberCheckDigit, compositeCheckDigit }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.15 }
    final override var CroppingTopOffset: CGFloat { return 0.6 }
    final override var CroppingWidthOffset: CGFloat { return 3.9 }
    final override var CroppingHeightOffset: CGFloat { return 2.8 }
    
    // MARK: Internal Properties
    final var MRZLine1: String?
    final var MRZLine2: String?
    
    final var PassportNumberCheckDigit: Int?
    final var DateOfBirthCheckDigit: Int?
    final var DateOfExpiryCheckDigit: Int?
    final var IdentityNumber: String?
    final var IdentityNumberCheckDigit: Int?
    final var CompositeCheckDigit: Int?
    
    // MARK: Public Properties
    @objc public final var mrzLine1: String? { get { return self.MRZLine1 } }
    @objc public final var mrzLine2: String? { get { return self.MRZLine2 } }
    
    @objc public final var passportNumberCheckDigit: Int { get { return self.PassportNumberCheckDigit ?? -1 } }
    @objc public final var dateOfBirthCheckDigit: Int { get { return self.DateOfBirthCheckDigit ?? -1 } }
    @objc public final var dateOfExpiryCheckDigit: Int { get { return self.DateOfExpiryCheckDigit ?? -1 } }
    @objc public final var identityNumber: String? { get { return self.IdentityNumber } }
    @objc public final var identityNumberCheckDigit: Int { get { return self.IdentityNumberCheckDigit ?? -1 } }
    @objc public final var compositeCheckDigit: Int { get { return self.CompositeCheckDigit ?? -1 } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mrzLine1, forKey: .mrzLine1)
        try container.encode(mrzLine2, forKey: .mrzLine2)
        try container.encode(passportNumberCheckDigit, forKey: .passportNumberCheckDigit)
        try container.encode(dateOfBirthCheckDigit, forKey: .dateOfBirthCheckDigit)
        try container.encode(dateOfExpiryCheckDigit, forKey: .dateOfExpiryCheckDigit)
        try container.encode(identityNumber, forKey: .identityNumber)
        try container.encode(identityNumberCheckDigit, forKey: .identityNumberCheckDigit)
        try container.encode(compositeCheckDigit, forKey: .compositeCheckDigit)

        try super.encode(to: encoder)
    }

}
