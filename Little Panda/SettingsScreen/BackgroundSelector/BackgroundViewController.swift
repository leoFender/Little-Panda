import UIKit

class BackgroundViewController: BaseViewController {

    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private var transitionController: ZoomTransitionController!
    private var imagePicker = UIImagePickerController()
    fileprivate var selectedIndexPath: IndexPath?
    
    @ViewModel var viewModel: BackgroundSelectorViewModel
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        viewModel.setupDataSource(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.reloadCollectionData()
        transitionController = ZoomTransitionController()
    }
    
    private func presentImagePicker() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func imageSelected(_ image: UIImage) {
        do {
            try image.saveToFile()
            Config.backgroundImageName = UIImage.customImageSelectedKey()
        } catch {
            print(error)
        }
    }
}

extension BackgroundViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = (info[.originalImage] as? UIImage)?.fixedOrientation() else {
            return
        }
        imageSelected(image)
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension BackgroundViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let name = viewModel.name(with: indexPath)
        if name == "Gallery Icon" {
            presentImagePicker()
            return
        }
        
        selectedIndexPath = indexPath
        router.zoom(.zoomBackground(name), from: self, with: transitionController)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * 3
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
      return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
      return sectionInsets.left
    }
}

extension BackgroundViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        guard let indexPath = selectedIndexPath else {
            return
        }
        let cell = collectionView.cellForItem(at: indexPath) as! BackgroundCollectionViewCell
        let cellFrame = collectionView.convert(cell.frame, to: view)

        if cellFrame.minY < collectionView.contentInset.top {
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        } else if cellFrame.maxY > view.frame.height - collectionView.contentInset.bottom {
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        guard let indexPath = selectedIndexPath else {
            return nil
        }
        let cell = collectionView.cellForItem(at: indexPath) as! BackgroundCollectionViewCell
        return cell.imageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        guard let indexPath = selectedIndexPath else {
            return nil
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! BackgroundCollectionViewCell

        let cellFrame = collectionView.convert(cell.frame, to: view)

        if cellFrame.minY < collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX,
                          y: collectionView.contentInset.top,
                          width: cellFrame.width,
                          height: cellFrame.height - (collectionView.contentInset.top - cellFrame.minY))
        }

        return cellFrame
    }
}
