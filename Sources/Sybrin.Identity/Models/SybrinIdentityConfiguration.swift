//
//  SybrinIdentityConfiguration.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/09.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import AVFoundation
import Sybrin_Common

@objc public final class SybrinIdentityConfiguration: NSObject, SybrinCommonConfiguration {
    
    // MARK: Internal Properties
    // Common
    final var License: String
    
    static var OverlayColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
    static var OverlayLabelTextColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static var OverlaySubLabelTextColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    static var OverlayBorderColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    static var OverlayBorderThickness: CGFloat = 4
    static var OverlayBorderLength: CGFloat = 30
    
    static var OverlayBlurStyle: UIBlurEffect.Style = .dark
    static var OverlayBlurIntensity: CGFloat = 0.8
    
    static var CameraPosition: AVCaptureDevice.Position = .back
    
    static var EnvironmentKey: String = "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"
    
    //"jeJMnE9i4lXNAy0F56ll0J5YiQIytSW2RKYnP5JrrL4jf774FgIMCYnOuc86xf7wdHpQi4i5dj22J9GxwX7NmeXay+9fE0JxcTxw1d9ZBKFH1FGNqEfiMmJoaoVbJ4a9N4i+5mKJHaoy0i1ms+evzyrugWBVojCkznAMCxsg5qA13B4Vx62CNv84I/HQ+CX5Vtc7Yg4BZgXBw1StooPr/qQfcdYE46UfUGEXPdbDjCHDw4/tGsDSn2nqWkHP6h5J6g1rtm77KWdyx2uCp9McQ54QSs9OPpeAam8tuIIoJBJkn3h7ZVEb/2AqLzBoVB3/Il6za8A+gYoGHm4srCxnuNr8RH+4DFYoFfMHNYRupuC8B/lVBGDdQS2IKAWLFQFx9U2yqAXkG7hgjvwRN0cass8WOkHO1T0SmJ16l7RAKeGeQjkQDPMZJyxf+vQHj3rbsJcrppRytjYHAMoGaysu4sDuso2rwWvndzPVgsh6oA1BNWpPOe204DxTR6T4V+bCLkK+wLfNqW5//viY8PlDwgyDUBQSnzYIQA0XmSA6i5LFI/kY8S8PpzoDWeCw9lIp7l9NuRVzUKZrOnjmkviE8hCt7fklzKv0G1cDcfilaylvZyjz2W7Fnb+Pw9mWxBYwSGpIBq7o3uHvz30luZJIa0DZSzoDol/2t/8lmPwwakegCdRrpl4Av83jUx0wTSYAtT3mzMnk5oIKLtXoWn/6W7AdT2UfVTM4IxPRQ3908T47poo0MdUh5JOgEHpIuhmK9Qv642yXNY+Ms+JSDklPIikkgHzLA+mFbzmr/+2Pjcjq2vpe1loSsNW7nJPylG87P+Rb3+trHIpwvYBSH5qweTfBIe0jzXL1sBXBpTyVuYQN/91Gkex6a+64l9aIBKEpqJju/Cb8qlHYP7OxCcWR6XWjRzHeAowbRgM8zCmFkWJHCw3f7gE8w6kHgLFHCI6Y7O/jZpYgfI6QULepJVYGqG7/P8WgC8ySYAawYtyYbnKfHVkGva3LcAt+I2oy8g5L9/Zrlp/t3Vi9XNWzxZKxv/Y48Ml20HAAl6dl93mLSzwH3efGqxpUzH++8ttYvryw9Ts+wib2ORzLbuPupRs6xFvLGB9QaVEB8/WN+po8vCJG+ob5ONd7R6zxrEVJ+oYRhUbkOJSGidfX84PEP7N58JpBVy/EWO9j28/nkEgdkfE6jV3wfgZmuuwdPuPWlijhZuorPBJIv4EMFgrtJDwCo+uesAKv2vE+tbk71oVkxWZFQGiQAOdrCqn8WvEg2wIGHfKbBzcgKPV6pbcfTLr+0Av3sE5KmBymx3YRri0XV1Fl/JyxoYTPWxiI83DVrOMAzvg/16CNHbzG6ZCvHsSIRxNefJaHCe/VE/+Q36avvGo="

    // Identity
    static var OverlayBrandingTitleText: String = ""
    static var OverlayBrandingTitleColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    static var OverlayBrandingSubtitleText: String = ""
    static var OverlayBrandingSubtitleColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    static var EnableBackButton: Bool = true
    static var EnableSwipeRightGesture: Bool = true
    static var ShowFlashButton: Bool = true
    
    static var DisplayToastMessages: Bool = true
    static var SaveImages: Bool = false
    
    static var CutoutCornerRadius: CGFloat = 0
    
    static var EnableMultiPhaseVerification: Bool = false
    static var EnableHelpMessages: Bool = false
    
    static var CorrelationID:String?
    
    static var EnablePartialScanning: Bool = true
    
    static var CustomAuthorizationToken: String?
    
    static var Language:  Language? = .ENGLISH

    // MARK: Public Properties
    // Common
    @objc public final var license: String { return License }
    
    @objc public final var overlayColor: UIColor = SybrinIdentityConfiguration.OverlayColor
    @objc public final var overlayLabelTextColor: UIColor = SybrinIdentityConfiguration.OverlayLabelTextColor
    @objc public final var overlaySubLabelTextColor: UIColor = SybrinIdentityConfiguration.OverlaySubLabelTextColor
    
    @objc public final var overlayBorderColor: UIColor = SybrinIdentityConfiguration.OverlayBorderColor
    @objc public final var overlayBorderThickness: CGFloat = SybrinIdentityConfiguration.OverlayBorderThickness
    @objc public final var overlayBorderLength: CGFloat = SybrinIdentityConfiguration.OverlayBorderLength
    
    @objc public final var overlayBlurStyle: UIBlurEffect.Style = SybrinIdentityConfiguration.OverlayBlurStyle
    @objc public final var overlayBlurIntensity: CGFloat = SybrinIdentityConfiguration.OverlayBlurIntensity
    
    @objc public final var cameraPosition: AVCaptureDevice.Position = SybrinIdentityConfiguration.CameraPosition
    
    @objc public final var environmentKey: String = SybrinIdentityConfiguration.EnvironmentKey
    
    // Identity
    @objc public final var overlayBrandingTitleText: String = SybrinIdentityConfiguration.OverlayBrandingTitleText
    @objc public final var overlayBrandingTitleColor: UIColor = SybrinIdentityConfiguration.OverlayBrandingTitleColor
    
    @objc public final var overlayBrandingSubtitleText: String = SybrinIdentityConfiguration.OverlayBrandingSubtitleText
    @objc public final var overlayBrandingSubtitleColor: UIColor = SybrinIdentityConfiguration.OverlayBrandingSubtitleColor
    
    @objc public final var enableBackButton: Bool = SybrinIdentityConfiguration.EnableBackButton
    @objc public final var enableSwipeRightGesture: Bool = SybrinIdentityConfiguration.EnableSwipeRightGesture
    @objc public final var showFlashButton: Bool = SybrinIdentityConfiguration.ShowFlashButton
    
    @objc public final var displayToastMessages: Bool = SybrinIdentityConfiguration.DisplayToastMessages
    @objc public final var saveImages: Bool = SybrinIdentityConfiguration.SaveImages
    
    @objc public final var cutoutCornerRadius: CGFloat = SybrinIdentityConfiguration.CutoutCornerRadius
    
    @objc public final var enableMultiPhaseVerification: Bool = SybrinIdentityConfiguration.EnableMultiPhaseVerification
    @objc public final var enableHelpMessages: Bool = SybrinIdentityConfiguration.EnableHelpMessages
    @objc public final var correlationID:String? = SybrinIdentityConfiguration.CorrelationID
    
    @objc public final var customAuthorizationToken: String? = SybrinIdentityConfiguration.CustomAuthorizationToken
    
    public final var language: Language? = SybrinIdentityConfiguration.Language
    
    // MARK: Initializers
    @objc public init(license: String) {
        self.License = license
    }
    
}

public enum Language: Int, RawRepresentable {
    case FILIPINO
    case ENGLISH

    public typealias RawValue = String

    public var rawValue: RawValue {
        switch self {
            case .FILIPINO:
                return "FILIPINO"
            case .ENGLISH:
                return "ENGLISH"
        }
    }

    public init?(rawValue: RawValue) {
        switch rawValue {
            case "FILIPINO":
                self = .FILIPINO
            case "ENGLISH":
                self = .FILIPINO
            default:
                return nil
        }
    }
}
