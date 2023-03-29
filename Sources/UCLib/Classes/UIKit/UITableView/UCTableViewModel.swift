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
    //associatedtype DataItem
    //not overly happy that I can't pull the cell type from the model but oh well
    func tableView(_ tableView:UITableView, requestedCell cell: UITableViewCell, indexPath : IndexPath)
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

    class  UCTableViewModelConfiguration
    {
        var cellReuseIdentifier : String = "cell"
        var reuseDemux : ReuseDemux?
        
        init (cellIdentifier : String)
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
    var delegate : (any UCTableViewModelDelegate)?
    
    init(tableView: UITableView, config: UCTableViewModelConfiguration) {
        self.tableView = tableView
        self.configuration = config;
        super.init()
        let snapshot = buildSnapshot()
        update(snapshot: snapshot)
    }
    
    public func update(snapshot:Snapshot)
    {
        dataSource.apply(snapshot)
    }

    
    func buildSnapshot() -> Snapshot
    {
        let snapshot = Snapshot()
        fatalError("")
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
            cell.consume(cellDataForItem(item: item))
            delegate?.tableView(tableView, requestedCell: cell, indexPath : indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    //This allows for relieve the cell of potentially neededing access to the model
    func cellDataForItem(item:Item) -> CellDataItem
    {
        fatalError("cellDataForItem MUST be implemented by TableViewModel subclass")
    }
}
