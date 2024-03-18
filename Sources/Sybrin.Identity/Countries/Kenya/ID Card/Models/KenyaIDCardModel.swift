//
//  KenyaIDCardModel.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/05.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit

@objc public final class KenyaIDCardModel: IDCardModel {
    
    // MARK: Private Properties
    private enum CodingKeys: String, CodingKey { case mrzLine1, mrzLine2, mrzLine3, serialNumber, serialNumberCheckDigit, optionalData1, optionalData2, dateOfBirthCheckDigit, dateOfExpiry, dateOfExpiryCheckDigit, compositeCheckDigit }
    
    // MARK: Overrided Offsets
    final override var CroppingLeftOffset: CGFloat { return 0.5 }
    final override var CroppingTopOffset: CGFloat { return 1.6 }
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
    
    final var SerialNumber: String?
    final var SerialNumberCheckDigit: Int?
    final var OptionalData1: String?
    final var OptionalData2: String?
    final var DateOfBirthCheckDigit: Int?
    final var DateOfExpiry: Date?
    final var DateOfExpiryCheckDigit: Int?
    final var CompositeCheckDigit: Int?
    
    // MARK: Public Properties
    @objc public final var mrzLine1: String? { get { return self.MRZLine1 } }
    @objc public final var mrzLine2: String? { get { return self.MRZLine2 } }
    @objc public final var mrzLine3: String? { get { return self.MRZLine3 } }
    
    @objc public final var serialNumber: String? { get { return self.SerialNumber } }
    @objc public final var serialNumberCheckDigit: Int { get { return self.SerialNumberCheckDigit ?? -1 } }
    @objc public final var optionalData1: String? { get { return self.OptionalData1 } }
    @objc public final var optionalData2: String? { get { return self.OptionalData2 } }
    @objc public final var dateOfBirthCheckDigit: Int { get { return self.DateOfBirthCheckDigit ?? -1 } }
    @objc public final var dateOfExpiry: Date? { get { return self.DateOfExpiry } }
    @objc public final var dateOfExpiryCheckDigit: Int { get { return self.DateOfExpiryCheckDigit ?? -1 } }
    @objc public final var compositeCheckDigit: Int { get { return self.CompositeCheckDigit ?? -1 } }
    
    // MARK: Public Methods
    public final override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(mrzLine1, forKey: .mrzLine1)
        try container.encode(mrzLine2, forKey: .mrzLine2)
        try container.encode(mrzLine3, forKey: .mrzLine3)
        try container.encode(serialNumber, forKey: .serialNumber)
        try container.encode(serialNumberCheckDigit, forKey: .serialNumberCheckDigit)
        try container.encode(optionalData1, forKey: .optionalData1)
        try container.encode(optionalData2, forKey: .optionalData2)
        try container.encode(dateOfBirthCheckDigit, forKey: .dateOfBirthCheckDigit)
        try container.encode(dateOfExpiry, forKey: .dateOfExpiry)
        try container.encode(dateOfExpiryCheckDigit, forKey: .dateOfExpiryCheckDigit)
        try container.encode(compositeCheckDigit, forKey: .compositeCheckDigit)

        try super.encode(to: encoder)
    }

}
