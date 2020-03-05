//
//  UCFetchedResultsCoordinator.swift
//
//  Created by Guy Umbright on 12/17/14.
//  Copyright (c) 2014 Umbright Consulting, Inc. All rights reserved.
//

import UIKit
import CoreData

class UCFetchedResultsCoordinator<NSFetchRequestResult> : NSObject, NSFetchedResultsControllerDelegate
{
//    unowned var fetchedResultsTableCoordinatorDelegate:AnyObject
    var fetchedResultsController:NSFetchedResultsController<CoreData.NSFetchRequestResult>?
    var tableView:UITableView?
    var ignoreUpdates = false
    
    class func coordinatorForFetchedResultsController(fetchedResultsController:NSFetchedResultsController<CoreData.NSFetchRequestResult>, table:UITableView) -> UCFetchedResultsCoordinator
    {
        return UCFetchedResultsCoordinator(controller:fetchedResultsController,table:table)
    }
    

    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    init(controller:NSFetchedResultsController<CoreData.NSFetchRequestResult>, table:UITableView)
    {
        super.init()
        self.fetchedResultsController = controller;
        self.fetchedResultsController?.delegate = self;
        self.tableView = table;
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func controllerWillChangeContent(_ controller:NSFetchedResultsController<CoreData.NSFetchRequestResult>)
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
    func controllerDidChangeContent(_ controller:NSFetchedResultsController<CoreData.NSFetchRequestResult>)
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
    func controller(_ controller: NSFetchedResultsController<CoreData.NSFetchRequestResult>,
                    didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        if ignoreUpdates {return}
        switch (type)
        {
        case NSFetchedResultsChangeType.delete:
            handleDelete(indexPath: indexPath!)
            
        case NSFetchedResultsChangeType.insert:
            handleInsert(indexPath: newIndexPath!)
            
        case NSFetchedResultsChangeType.move:
            handleMove(oldIndexPath: indexPath!,newIndexPath:newIndexPath!);
            
        case NSFetchedResultsChangeType.update:
            handleUpdate(indexPath: indexPath!)
            
        default:
            break
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleDelete(indexPath:IndexPath)
    {
        deleteTableRowAtIndexPath(indexPath: indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleInsert(indexPath:IndexPath)
    {
        insertTableRowAtIndexPath(indexPath: indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleMove(oldIndexPath:IndexPath,  newIndexPath:IndexPath)
    {
        deleteTableRowAtIndexPath(indexPath: oldIndexPath)
        insertTableRowAtIndexPath(indexPath: newIndexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func handleUpdate(indexPath:IndexPath)
    {
        reloadTableRowAtIndexPath(indexPath: indexPath)
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func deleteTableRowAtIndexPath(indexPath:IndexPath)
    {
        if let table = self.tableView
        {
            table.deleteRows(at: [indexPath], with:UITableView.RowAnimation.automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func insertTableRowAtIndexPath(indexPath:IndexPath)
    {
        if let table = self.tableView
        {
            table.insertRows(at: [indexPath], with:UITableView.RowAnimation.automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func reloadTableRowAtIndexPath(indexPath:IndexPath)
    {
        if let table = self.tableView
        {
            table.reloadRows(at: [indexPath], with:UITableView.RowAnimation.automatic)
        }
    }
    
    /////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////
    func controller(controller: NSFetchedResultsController<CoreData.NSFetchRequestResult>, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                        atIndex sectionIndex: Int,
                                        forChangeType type: NSFetchedResultsChangeType)
    {
        if ignoreUpdates {return}
        switch (type)
        {
        case NSFetchedResultsChangeType.delete:
            self.tableView?.deleteSections(IndexSet(integer: sectionIndex), with: UITableView.RowAnimation.fade)
            
        case NSFetchedResultsChangeType.insert:
            self.tableView?.insertSections(IndexSet(integer: sectionIndex), with:UITableView.RowAnimation.automatic);
            
        case NSFetchedResultsChangeType.update:
            self.tableView?.reloadSections(IndexSet(integer: sectionIndex), with:UITableView.RowAnimation.automatic);
            
            default:
                break
         }
    }
}
