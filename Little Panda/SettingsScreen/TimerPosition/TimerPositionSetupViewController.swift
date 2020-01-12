import UIKit

class TimerPositionSetupViewController: BaseViewController {

    @IBOutlet weak var vertical: NSLayoutConstraint!
    @IBOutlet weak var horizontal: NSLayoutConstraint!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    private var initialX: CGFloat = 0
    private var initialY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(TimerPositionSetupViewController.panDidRecognize(_:)))
        pan.delaysTouchesBegan = false
        pan.delaysTouchesEnded = false
        
        testLabel.addGestureRecognizer(pan)
        
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(TimerPositionSetupViewController.saveButtonDidTap))
        
        let recenterButton = UIBarButtonItem(title: "Center",
                                             style: .plain,
                                             target: self,
                                             action: #selector(TimerPositionSetupViewController.recenter))
        
        navigationItem.rightBarButtonItems = [saveButton, recenterButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurateUI()
    }
    
    private func configurateUI() {
        testLabel.loadTimerConfig()
        
        background.image = UIImage(named: Config.backgroundImageName)
        
        let currentPosition = Config.timerLabelPosition
        UIView.animate(withDuration: 0.5, animations: {
            self.vertical.constant = currentPosition.vertical
            self.horizontal.constant = currentPosition.horizontal
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func saveButtonDidTap() {
        let position = PositionConfiguration(vertical: vertical.constant, horizontal: horizontal.constant)
        Config.timerLabelPosition = position

        navigationController?.popViewController(animated: true)
    }
    
    @objc private func recenter() {
        UIView.animate(withDuration: 0.5) {
            self.horizontal.constant = 0
            self.vertical.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func panDidRecognize(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            initialX = horizontal.constant
            initialY = vertical.constant
        case .changed:
            let translation = sender.translation(in: view)
            horizontal.constant = initialX + translation.x
            vertical.constant = initialY + translation.y
        default:
            break
        }
    }
}
