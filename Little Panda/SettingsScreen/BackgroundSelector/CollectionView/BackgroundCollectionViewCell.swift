import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectedLabel: UILabel!
    
    override func awakeFromNib() {
        selectedLabel.layer.borderColor = UIColor.systemGray.cgColor
        selectedLabel.textColor = UIColor.darkText
        selectedLabel.layer.borderWidth = 10.0
        selectedLabel.layer.cornerRadius = 5.0
        selectedLabel.clipsToBounds = true
    }
    
    func configure(_ object: BackgroundCollectionEntry) {
        imageView.image = UIImage(named: object.name)
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        
        if object.name == "Gallery Icon" {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
        
        selectedLabel.isHidden = !object.isSelected
    }
}
