//
//  UCSystemTools.swift
//  UCTools
//
//  Created by Guy Umbright on 12/4/17.
//  Copyright © 2017 Guy Umbright. All rights reserved.
//

import UIKit

//MARK: conformsToMinimumVersion
public func conformsToMinimumVersion(major:UInt, minor:UInt) -> Bool
{
    let version = UIDevice.current.systemVersion
    return conformsToMinimumVersion(systemVersion: version, major: major, minor: minor)
}

public func conformsToMinimumVersion(systemVersion:String,major:UInt, minor:UInt) -> Bool
{
    var result = false
    let parts = systemVersion.split(separator: ".")
    
    if parts.count == 2
    {
//        if parts[0].count > 0 && parts[1].count > 0
//        {
            let currentMajor = UInt(parts[0])!
            let currentMinor = UInt(parts[1])!
            
            if currentMajor > major
            {
                result = true
            }
            else if currentMajor == major
            {
                result = currentMinor >= minor
            }
//        }
    }
    return result
}
