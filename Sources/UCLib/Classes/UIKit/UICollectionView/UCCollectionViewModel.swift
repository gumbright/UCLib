//
//  CollectionViewModel.swift
//
//  Created by Guy Umbright on 3/26/23.
//  Based off code by Eilon Krauthammer DiffableViewModel
//

/*
 Usage:
 
 Create a subclass specifying CellType (this is still a weak point multi cell type applications), SectionIdType, ItemIdType
 
 MUST override cellDataForDataItem & buildSnapshot
 
 cellDataForDataItem is what maps between the datasource item id and the actual data needed (eg NSMangedObjectId & some managed object)
 Cells must conform to UCConsumer protocol
 */

import UIKit

public protocol UCCollectionViewModelDelegate
{
    //not overly happy that I can't pull the cell type from the model but oh well, think its where a associatedtype would come in
    func collectionView(_ collectionView:UICollectionView, requestedCell cell: UICollectionViewCell, index:IndexPath)
}

open class UCCollectionViewModel<CellType: UICollectionViewCell & UCConsumer, SectionIdType : Hashable, ItemIdType : Hashable>: NSObject
{
    //this is a class instead of a struct for reasons I cannot recall and if I continue to not should consider changing it
    public class  UCCollectionViewModelConfiguration
    {
        public var cellReuseIdentifier : String = "cell"
        public var reuseDemux : ReuseDemux?
        public var supplementaryViewProvider : DataSource.SupplementaryViewProvider?
        
        public init (cellIdentifier : String)
        {
            cellReuseIdentifier = cellIdentifier
        }
    }
    
    // Typealiases for our convenience
    public typealias CellDataItem = CellType.ConsumedItem
    public typealias Item = ItemIdType
    public typealias DataSource = UICollectionViewDiffableDataSource<SectionType, Item>
    public typealias ReuseDemux = (_ index : IndexPath, _ item : Item, _ default : String) -> String
    public typealias SectionType = SectionIdType
    public typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, Item>
    
    weak var collectionView: UICollectionView?
    
    public lazy var dataSource : DataSource = {
        guard let collectionView else { fatalError() }
        let dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        if configuration.supplementaryViewProvider != nil
        {
            dataSource.supplementaryViewProvider = configuration.supplementaryViewProvider
        }
        return dataSource
    }()
    
    private var configuration : UCCollectionViewModelConfiguration
    public var delegate : UCCollectionViewModelDelegate?
    
    public init(collectionView: UICollectionView, config: UCCollectionViewModelConfiguration)
    {
        self.collectionView = collectionView
        self.configuration = config;
        super.init()
        let snapshot = buildSnapshot()
        update(snapshot: snapshot)
    }
    
    open func update(snapshot : Snapshot)
    {
        dataSource.apply(snapshot)
    }
    
    open func buildSnapshot() -> Snapshot //NSDiffableDataSourceSnapshot<SectionType, Item>
    {
        let snapshot = Snapshot() //NSDiffableDataSourceSnapshot<SectionType, Item>()
        fatalError("buildSnapshot MUST be implemented by UCCollectionViewModel subclass")
        return snapshot
    }
    
    open func cellDataForItem(item:Item) -> CellDataItem
    {
        fatalError("cellDataForItem MUST be implemented by UCCollectionViewModel subclass")
    }
}

extension UCCollectionViewModel {
    private func cellProvider(_ collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell?
    {
        //call back to provide item & index path and get back reuse identifier
        var reuseId = configuration.cellReuseIdentifier
        if (configuration.reuseDemux != nil)
        {
            reuseId = configuration.reuseDemux!(indexPath,item,configuration.cellReuseIdentifier)
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? CellType
        {
            cell.consume(cellDataForItem(item: item))
            delegate?.collectionView(collectionView, requestedCell: cell, index: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }

}
