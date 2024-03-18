//
//  UIImage.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/09/03.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

import UIKit
import Sybrin_Common

extension UIImage {
    
    func GetCropRect(_ leftOffset: CGFloat, _ topOffset: CGFloat, _ widthOffset: CGFloat, _ heightOffset: CGFloat, _ frame: CGRect) -> CGRect {
        let imageWidth = self.size.width
        let imageHeight = self.size.height
        
        var x: Int = Int(frame.minX - (frame.size.width * leftOffset))
        x = x <= 0 ? 0 : x
        x = x >= Int(imageWidth) ? Int(imageWidth) : x
        
        var y: Int = Int(frame.minY - (frame.size.height * topOffset))
        y = y <= 0 ? 0 : y
        y = y >= Int(imageHeight) ? Int(imageHeight) : y
        
        var width: Int = Int(frame.size.width * widthOffset)
        width = width <= 0 ? 1: width
        width = (x + width) > Int(imageWidth) ? (Int(imageWidth) - x) : width
        
        var height: Int = Int(frame.size.height * heightOffset)
        height = height <= 0 ? 1 : height
        height = (y + height) > Int(imageHeight) ? (Int(imageHeight) - y) : height
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func CropImage(_ rect: CGRect, padding: CGFloat = 0) -> UIImage {
        return CropImage(rect, paddingVertical: padding, paddingHorizontal: padding)
    }
    
    func CropImage(_ rect: CGRect, paddingVertical: CGFloat = 0, paddingHorizontal: CGFloat = 0) -> UIImage {
        let croppedCGImageOptional = self.cgImage?.cropping(to: CGRect(x: rect.minX - paddingHorizontal, y: rect.minY - paddingVertical, width: rect.width + paddingHorizontal * 2, height: rect.height + paddingVertical * 2))

        guard let croppedCGImage = croppedCGImageOptional else {
            "CGImage was nil".log(.Error)
            return self
        }

        return UIImage(cgImage: croppedCGImage)
    }
    
}
