//
//  NSManagedObjectExtension.swift
//
//  Created by Guy Umbright on 7/6/17.
//  Copyright © 2017 Umbright Consulting, Inc. All rights reserved.
//

import Foundation
import CoreData

// For many of these extension methods to work, an extension needs to be create for the NSManagedObject classes that
// defines the entityName() method.  This allows things like <Classname>.allInContext(...)

public extension NSManagedObject
{
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func allInContext<T:NSFetchRequestResult>(context:NSManagedObjectContext,predicate:NSPredicate?,sortedBy:String?,ascending:Bool = false) -> [T]
    {
        let request = NSFetchRequest<T>(entityName: self.entityName())
        request.predicate = predicate
        if let sortField = sortedBy
        {
            let sortDesc = NSSortDescriptor(key: sortField, ascending: ascending)
            request.sortDescriptors = [sortDesc]
        }
        
        var result : [T] = Array<T>()
        context.performAndWait {
            do {
                result = try context.fetch(request)
            }
            catch {}
        }
        
        return result
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func firstInContext<T:NSManagedObject>(context:NSManagedObjectContext,predicate:NSPredicate?,sortedBy:String?,ascending:Bool = false) -> T?
    {
        let result:[T] = self.allInContext(context: context, predicate: predicate, sortedBy: sortedBy, ascending:ascending)
        if result.count > 0
        {
            return result[0];
        }
        else
        {
            return nil
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func countWith(predicate:NSPredicate?, context:NSManagedObjectContext) -> Int
    {
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName())
        var result = 0
        
        request.predicate = predicate
        context.performAndWait {
            do
            {
                result = try context.count(for: request)
            }
            catch
            {
                
            }
        }
        return result
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func create<T:NSManagedObject>(context:NSManagedObjectContext) -> T?
    {
        if let entity = self.entityDescription(context: context)
        {
            return T(entity: entity, insertInto: context)
        }
        else
        {
            return nil
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func create<T:NSManagedObject>(context:NSManagedObjectContext, objectName:String) -> T?
    {
        //if let entity = self.HWE_entityDescription(context: context)
        if let entity = NSEntityDescription.entity(forEntityName: objectName, in: context)
        {
            return T(entity: entity, insertInto: context)
        }
        else
        {
            return nil
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func entityDescription(context:NSManagedObjectContext) -> NSEntityDescription?
    {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: context)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public class func entityName() -> String
    {
        return String(describing:Self.self)
//        var entityName = self.entityName()
//
//        if entityName == nil
//        {
//            entityName = NSStringFromClass(self).components(separatedBy: ".").last!
//        }
//
//        return entityName!
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public @objc class func entityName() -> String?
    {
        return nil
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public func delete()
    {
        self.deleteFromContext(context:self.managedObjectContext!)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    public func deleteFromContext(context:NSManagedObjectContext)
    {
        do {
            let objInContext = try context.existingObject(with: self.objectID)
            context.delete(objInContext)
        }
        catch
        {
            //do nothing for now
        }
        
    }
 }
