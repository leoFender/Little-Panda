import UIKit

class ZoomPreviewViewController: BaseViewController {

    var imageName: String = ""
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(ZoomPreviewViewController.saveButtonDidTap))
        navigationItem.rightBarButtonItem = saveButton
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ZoomPreviewViewController.close))
        imageView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = UIImage(named: imageName)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        Config.backgroundImageName = imageName
        close()
    }
}

extension ZoomPreviewViewController: ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
    }

    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }

    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        return imageView
    }

    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        return view.convert(imageView.frame, to: view)
    }
}
