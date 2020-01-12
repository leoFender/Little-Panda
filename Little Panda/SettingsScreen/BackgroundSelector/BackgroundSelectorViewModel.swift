import Foundation
import UIKit

class BackgroundSelectorViewModel: NSObject {
    
    typealias BackgroundsDataSource = UICollectionViewDiffableDataSource<Int, String>
    
    private static let cellID = "BackgroundSelectionCell"
    private var dataSource: BackgroundsDataSource?
    
    static let imageNames = [
        "Autumn",
        "Beach",
        "Campfire",
        "Christmas Tree",
        "Clouds",
        "Dark Circles",
        "Drops",
        "Glitter Christmas Tree",
        "Green Leaf",
        "Heart",
        "Moon",
        "Mountain Snow",
        "Ocean Waves",
        "Panda Couple",
        "Pink Flowers",
        "Santa Ride Moon",
        "Santa Ride",
        "Small Panda",
        "Toy",
        "Toys",
        "Universe",
        "Water",
        "Winter",
        "Gallery Icon"
    ]
    
    func setupDataSource(_ collectionView: UICollectionView) {
        collectionView.register(BackgroundCollectionViewCell.self,
                                forCellWithReuseIdentifier: BackgroundSelectorViewModel.cellID)
        collectionView.register(UINib(nibName: "BackgroundCollectionViewCell", bundle: Bundle.main),
                                forCellWithReuseIdentifier: BackgroundSelectorViewModel.cellID)
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                        cellProvider:
            { (collection, indexPath, value) -> BackgroundCollectionViewCell? in

                let cell = collection.dequeueReusableCell(
                    withReuseIdentifier: BackgroundSelectorViewModel.cellID,
                    for: indexPath) as? BackgroundCollectionViewCell
                cell?.contentView.translatesAutoresizingMaskIntoConstraints = false
                cell?.configure(value)
                return cell
        })
    }
    
    func reloadCollectionData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(BackgroundSelectorViewModel.imageNames, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func name(with indexPath: IndexPath) -> String {
        return BackgroundSelectorViewModel.imageNames[indexPath.row]
    }
}
