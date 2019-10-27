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
    func resizeTo(_ newSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
