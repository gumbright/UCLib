//
//  UIXBlockNotificationManager.swift
//  Stadium
//
//  Created by Guy Umbright on 7/22/16.
//  Copyright © 2016 Umbright Consulting, Inc. All rights reserved.
//

import Foundation

public class UCBlockNotificationManager
{
    var notificationHandlerObjects:[String:AnyObject] = [:]
    
    public init()
    {
    }

    deinit
    {
        for (_,handler) in self.notificationHandlerObjects
        {
            NotificationCenter.default.removeObserver(handler)
        }
    }
    
    public func addHandler(_ tag:String, handler:AnyObject )
    {
        self.notificationHandlerObjects[tag] = handler
    }

    public func handlerForTag(_ tag:String) -> AnyObject?
    {
        guard !tag.isEmpty else
        {
            return nil
        }
        return self.notificationHandlerObjects[tag]
    }

    public func removeHandlerForTag(_ tag:String)
    {
        self.notificationHandlerObjects.removeValue(forKey: tag)
    }
    
    public func clearAllHandlers()
    {
        for (tag,handler) in notificationHandlerObjects
        {
            NotificationCenter.default.removeObserver(handler)
            removeHandlerForTag(tag)
        }
    }
}
