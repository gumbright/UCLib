//
//  SKPhysicsBodyExtentions.swift
//
//  Created by Guy Umbright on 7/18/19.
//  Copyright © 2019 Guy Umbright. All rights reserved.
//

import Foundation
import SpriteKit

extension SKPhysicsBody
{
    func setToNeutral()
    {
        affectedByGravity = false
        categoryBitMask = 0
        collisionBitMask = 0
        mass = 0
        friction = 0
    }
}
