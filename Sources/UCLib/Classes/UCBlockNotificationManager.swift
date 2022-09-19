//
//  UIXBlockNotificationManager.swift
//  Stadium
//
//  Created by Guy Umbright on 7/22/16.
//  Copyright © 2016 Umbright Consulting, Inc. All rights reserved.
//

import Foundation

class UCBlockNotificationManager
{
    var notificationHandlerObjects:[String:AnyObject] = [:]
    
    deinit
    {
        for (_,handler) in self.notificationHandlerObjects
        {
            NotificationCenter.default.removeObserver(handler)
        }
    }
    
    func addHandler(_ tag:String, handler:AnyObject )
    {
        self.notificationHandlerObjects[tag] = handler
    }

    func handlerForTag(_ tag:String) -> AnyObject?
    {
        guard !tag.isEmpty else
        {
            return nil
        }
        return self.notificationHandlerObjects[tag]
    }

    func removeHandlerForTag(_ tag:String)
    {
        self.notificationHandlerObjects.removeValue(forKey: tag)
    }
    
    func clearAllHandlers()
    {
        for (tag,handler) in notificationHandlerObjects
        {
            NotificationCenter.default.removeObserver(handler)
            removeHandlerForTag(tag)
        }
    }
}
