//
//  NSLayoutConstraintExtensions.swift
//  
//
//  Created by Guy Umbright on 11/4/19.
//

import UIKit

// TODO: add metrics keys and parm to constrainSubviewToSuperview

public extension NSLayoutConstraint
{
    enum BasicInset : String
    {
        case topInset = "topInset"
        case leftInset = "leftInset"
        case bottomInset = "bottomInset"
        case rightInset = "rightInset"
    }
    
    
    //not happy about Any
    static func constrainSubviewToSuperview(_ subview:UIView , metrics : [BasicInset:Any]? = nil)
    {
        guard let superview = subview.superview else {return}
        let emptyMetrics : [String:Any] = [BasicInset.topInset.rawValue:0,
                                           BasicInset.leftInset.rawValue:0,
                                           BasicInset.bottomInset.rawValue:0,
                                           BasicInset.rightInset.rawValue:0]

        let views  = ["subview":subview]
        
        var usedMetrics = emptyMetrics
        
        if metrics != nil
        {
            var fixedMetrics : [String : Any] = [:]
            metrics?.forEach({ (tuple) in
                fixedMetrics[tuple.key.rawValue] = tuple.value
            })
            usedMetrics.merge(fixedMetrics) { (_, newVal) -> Any in newVal}
        }
        
        let horz = NSLayoutConstraint.constraints(withVisualFormat: "|-(leftInset)-[subview]-(rightInset)-|", options: NSLayoutConstraint.FormatOptions(), metrics: usedMetrics, views: views)
        superview.addConstraints(horz)
        let vert = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(topInset)-[subview]-(bottomInset)-|", options: NSLayoutConstraint.FormatOptions(), metrics: usedMetrics, views: views)
        superview.addConstraints(vert)
    }
}
