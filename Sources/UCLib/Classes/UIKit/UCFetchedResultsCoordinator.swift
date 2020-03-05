//
//  UCFetchedResultsCoordinator.swift
//
//  Created by Guy Umbright on 12/17/14.
//  Copyright (c) 2014 Umbright Consulting, Inc. All rights reserved.
//

import UIKit
import CoreData

class UCFetchedResultsCoordinator : NSFetchedResultsControllerDelegate
{
//    unowned var fetchedResultsTableCoordinatorDelegate:AnyObject
    var fetchedResultsController:NSFetchedResultsController?
    var tableView:UITableView?
    var ignoreUpdates = false
    
    class func coordinatorForFetchedResultsController(fetchedResultsController:NSFetchedResultsController, table:UITableView) -> UIXFetchedResultsCoordinator
    {
        return UCFetchedResultsCoordinator(controller:fetchedResultsController,table:table)
    }
    

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    init(controller:NSFetchedResultsController, table:UITableView)
    {
        self.fetchedResultsController = controller;
        self.fetchedResultsController?.delegate = self;
        self.tableView = table;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func controllerWillChangeContent(controller:NSFetchedResultsController)
    {
        if ignoreUpdates {return}
        
        if let table = self.tableView
        {
            table.beginUpdates();
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func controllerDidChangeContent(controller:NSFetchedResultsController)
    {
        if ignoreUpdates {return}
        if let table = self.tableView
        {
            table.endUpdates();

        }
    }
    
    /////////////////////////////////////////////////////
    //
    ////////////////////////////////////////////////////
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?)
    {
        if ignoreUpdates {return}
        switch (type)
        {
        case NSFetchedResultsChangeType.Delete:
            handleDelete(indexPath!)
            
        case NSFetchedResultsChangeType.Insert:
            handleInsert(newIndexPath!)
            
        case NSFetchedResultsChangeType.Move:
            handleMove(indexPath!,newIndexPath:newIndexPath!);
            
        case NSFetchedResultsChangeType.Update:
            handleUpdate(indexPath!)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleDelete(indexPath:NSIndexPath)
    {
        deleteTableRowAtIndexPath(indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleInsert(indexPath:NSIndexPath)
    {
        insertTableRowAtIndexPath(indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleMove(oldIndexPath:NSIndexPath,  newIndexPath:NSIndexPath)
    {
        deleteTableRowAtIndexPath(oldIndexPath)
        insertTableRowAtIndexPath(newIndexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleUpdate(indexPath:NSIndexPath)
    {
        reloadTableRowAtIndexPath(indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func deleteTableRowAtIndexPath(indexPath:NSIndexPath)
    {
        if let table = self.tableView
        {
            table.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func insertTableRowAtIndexPath(indexPath:NSIndexPath)
    {
        if let table = self.tableView
        {
            table.insertRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func reloadTableRowAtIndexPath(indexPath:NSIndexPath)
    {
        if let table = self.tableView
        {
            table.reloadRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                        atIndex sectionIndex: Int,
                                        forChangeType type: NSFetchedResultsChangeType)
    {
        if ignoreUpdates {return}
        switch (type)
        {
            case NSFetchedResultsChangeType.Delete:
                self.tableView?.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: UITableViewRowAnimation.Fade)
            
            case NSFetchedResultsChangeType.Insert:
                self.tableView?.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation:UITableViewRowAnimation.Automatic);
            
            case NSFetchedResultsChangeType.Update:
                self.tableView?.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation:UITableViewRowAnimation.Automatic);
            
            default:
                break
         }
    }
}
