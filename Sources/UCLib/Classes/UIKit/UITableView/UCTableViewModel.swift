//
//  TableViewModel.swift
//
//  Created by Guy Umbright on 3/26/23.
//  Based off code by Eilon Krauthammer DiffableViewModel
//


import UIKit

/*
 Usage:
 
 Create a subclass specifying CellType (this is still a weak point multi cell type applications), SectionIdType, ItemIdType
 
 MUST override cellDataForDataItem & buildSnapshot
 
 cellDataForDataItem is what maps between the datasource item id and the actual data needed (eg NSMangedObjectId & some managed object)
 Cells must conform to UCConsumer protocol
 */

public protocol UCTableViewModelDelegate
{
    associatedtype ItemType

    func tableView(_ tableView:UITableView, requestedCell cell: UITableViewCell, indexPath : IndexPath, item : ItemType)
    func doThing(item : ItemType)
}

open class UCTableViewModel<CellType: UITableViewCell & UCConsumer, SectionIdType : Hashable, ItemIdType : Hashable>: NSObject
{
    // Typealiases for our convenience
    public typealias CellDataItem = CellType.ConsumedItem
    public typealias Item = ItemIdType
    public typealias DataSource = UITableViewDiffableDataSource<SectionType, Item>
    public typealias ReuseDemux = (_ index : IndexPath, _ item : Item, _ default : String) -> String
    public typealias SectionType = SectionIdType
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>

    public class  UCTableViewModelConfiguration
    {
        public typealias RequestedCellCallback = (CellType,CellDataItem,IndexPath) -> Void
        
        public var cellReuseIdentifier : String = "cell"
        public var reuseDemux : ReuseDemux?
        var requestedCellCallback : RequestedCellCallback?

        public init (cellIdentifier : String)
        {
            cellReuseIdentifier = cellIdentifier
        }
    }

    weak var tableView: UITableView?
    
    //public var dataSource: DataSource?
    public lazy var dataSource : DataSource = {
        guard let tableView else { fatalError() }
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        return dataSource
    }()
    
    private var configuration : UCTableViewModelConfiguration
    public var delegate : (any UCTableViewModelDelegate)?
    
    public init(tableView: UITableView, config: UCTableViewModelConfiguration)
    {
        self.tableView = tableView
        self.configuration = config;
        super.init()
        let snapshot = buildSnapshot()
        update(snapshot: snapshot)
    }
    
    open func update(snapshot:Snapshot)
    {
        dataSource.apply(snapshot)
    }
 
    open func buildSnapshot() -> Snapshot
    {
        let snapshot = Snapshot()
        fatalError("buildSnapshot MUST be implemented by UCTableViewModel subclass")
        return snapshot
    }
    
    private func cellProvider(_ tableView: UITableView, indexPath: IndexPath, item: Item) -> UITableViewCell?
    {
        //call back to provide item & index path and get back reuse identifier
        var reuseId = configuration.cellReuseIdentifier
        if (configuration.reuseDemux != nil)
        {
            reuseId = configuration.reuseDemux!(indexPath,item,configuration.cellReuseIdentifier)
        }
        
        let c = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        if let cell = c as? CellType
        {
            let itemData = cellDataForItem(item: item)
            cell.consume(itemData)
            //delegate?.tableView(tableView, requestedCell: cell, indexPath : indexPath, item : Item)
            //delegate?.doThing(item: Item)
            configuration.requestedCellCallback?(cell,itemData,indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    //This allows for relieve the cell of potentially neededing access to the model
    open func cellDataForItem(item:Item) -> CellDataItem
    {
        fatalError("cellDataForItem MUST be implemented by TableViewModel subclass")
    }
}
