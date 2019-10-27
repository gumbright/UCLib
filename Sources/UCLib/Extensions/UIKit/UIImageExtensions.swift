//
//  UIImageExtensions.swift
//  UCLib
//
//  Created by Guy Umbright on 10/26/19.
//

import UIKit
import CoreGraphics

public extension UIImage
{
    func resizeImage(_ image:UIImage, newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
