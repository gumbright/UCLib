//
//  UIImageExtensions.swift
//  UCLib
//
//  Created by Guy Umbright on 10/26/19.
//

import UIKit
import CoreGraphics

@available(iOS 10.0, *)
public extension UIImage
{
    func resizeTo(_ newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    //scale image to desired size (
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
    //just draw it into the box I say
    func resizeInto(_ newSize : CGSize) -> UIImage
    {
        let renderer = UIGraphicsImageRenderer(
            size: newSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: newSize
            ))
        }
        
        return scaledImage

    }
}
