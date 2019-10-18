//
//  CGRectExtensions.swift
//
//  Created by Guy Umbright on 7/8/19.
//  Copyright © 2019 Guy Umbright. All rights reserved.
//

import CoreGraphics

// MARK: Center
extension CGRect
{
    func center() -> CGPoint
    {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

// MARK: Left/Right
extension CGRect
{
    func lowerLeft() -> CGPoint
    {
        return CGPoint(x: self.minX, y: self.minY)
    }
    
    func lowerRight() -> CGPoint
    {
        return CGPoint(x: self.maxX, y: self.minY)
    }
    
    func upperLeft() -> CGPoint
    {
        return CGPoint(x: self.minX, y: self.maxY)
    }
    
    func upperRight() -> CGPoint
    {
        return CGPoint(x: self.maxX, y: self.maxY)
    }
}

// MARK: Mids
extension CGRect
{
    func midBottom() -> CGPoint
    {
        return CGPoint(x: self.midX, y: self.minY)
    }
    
    func midLeft() -> CGPoint
    {
        return CGPoint(x: self.minX, y: self.midY)
    }
    
    func midTop() -> CGPoint
    {
        return CGPoint(x: self.midX, y: self.maxY)
    }
    
    func midRight() -> CGPoint
    {
        return CGPoint(x: self.maxX, y: self.midY)
    }
}

// MARK: Halfs
extension CGRect
{
    func topHalf() -> CGRect
    {
        return self.trimBottom(midHeight())
    }
    
    func bottomHalf() -> CGRect
    {
        return self.trimTop(midHeight())
    }
    
    func leftHalf() -> CGRect
    {
        return self.trimRight(midWidth())
    }
    
    func rightHalf() -> CGRect
    {
        return self.trimLeft(midWidth())
    }
}

// MARK: Size mids
extension CGRect
{
    func midHeight() -> CGFloat
    {
        return self.height/2
    }
    
    func midWidth() -> CGFloat
    {
        return self.width/2
    }
}

// MARK: Edges
extension CGRect
{
    func topEdge() -> CGRect
    {
        return trimBottom(self.height-1)
    }
    
    func leftEdge() -> CGRect
    {
        return trimRight(self.width-1)
    }
    
    func bottomEdge() -> CGRect
    {
        return trimTop(self.height-1)
    }
    
    func rightEdge() -> CGRect
    {
        return trimLeft(self.width-1)
    }
}
    
// MARK: Trim
extension CGRect
{
    func trimBottom(_ amount:CGFloat) -> CGRect
    {
        let adjust = (self.height < amount) ? self.height : amount
        return CGRect(x: self.minX, y: self.minY+adjust, width: self.width, height: self.height - adjust)
    }

    func trimLeft(_ amount:CGFloat) -> CGRect
    {
        let adjust = (self.width < amount) ? self.width : amount
        return CGRect(x: self.minX+adjust, y: self.minY, width: self.width-adjust, height: self.height)
    }
    
    func trimTop(_ amount:CGFloat) -> CGRect
    {
        let adjust = (self.height < amount) ? self.height : amount
        return CGRect(x: self.minX, y: self.minY, width: self.width, height: self.height - adjust)
    }
    
    func trimRight(_ amount:CGFloat) -> CGRect
    {
        let adjust = (self.height < amount) ? self.height : amount
        return CGRect(x: self.minX, y: self.minY, width: self.width-adjust, height: self.height)
    }
}

// MARK: Grow
extension CGRect
{
    func growDown(_ amount:CGFloat) -> CGRect
    {
        return CGRect(x: minX, y: minY-amount, width: width, height: height+amount)
    }
    
    func growUp(_ amount:CGFloat) -> CGRect
    {
        return CGRect(x: minX, y: minY, width: width, height: height+amount)
    }
    
    func growRight(_ amount:CGFloat) -> CGRect
    {
        return CGRect(x: minX, y: minY, width: width+amount, height: height)
    }
    
    func growLeft(_ amount:CGFloat) -> CGRect
    {
        return CGRect(x: minX-amount, y: minY, width: width+amount, height: height)
    }
    
}
