//
//  UIView_extension.swift
//  tabletest
//
//  Created by Guy Umbright on 3/1/20.
//  Copyright © 2020 Umbright Consutling, Inc. All rights reserved.
//

import UIKit

extension UIView
{
    //let myCustomView: CustomView = UIView.fromNib()
    //or
    //let myCustomView: CustomView = .fromNib()
    
    public class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
