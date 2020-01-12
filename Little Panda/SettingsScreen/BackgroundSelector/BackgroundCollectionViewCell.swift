import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func configure(_ object: String) {
        imageView.image = UIImage(named: object)
        imageView.layer.cornerRadius = 5.0
        imageView.clipsToBounds = true
        
        if object == "Gallery Icon" {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
}
