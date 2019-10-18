//
//  CGPointExtensions.swift
//
//  Created by Guy Umbright on 7/8/19.
//  Copyright © 2019 Guy Umbright. All rights reserved.
//

import CoreGraphics

public extension CGPoint
{
    func offset(x:CGFloat, y:CGFloat) -> CGPoint
    {
        return CGPoint(x:self.x+x,y:self.y+y)
    }
    
    func offsetX(x:CGFloat) -> CGPoint
    {
        return self.offset(x: x, y: 0)
    }
    
    func offsetY(y:CGFloat) -> CGPoint
    {
        return self.offset(x: 0, y: y)
    }
}
