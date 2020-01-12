import UIKit

class TimerViewController: BaseViewController, TimerDelegate {

    @ViewModel var viewModel: TimerViewModel
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var vertical: NSLayoutConstraint!
    @IBOutlet weak var horizontal: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        if let tap = navigationController?.barHideOnTapGestureRecognizer,
            let swipe = navigationController?.barHideOnSwipeGestureRecognizer {
            
            navigationController?.hidesBarsOnTap = true
            navigationController?.hidesBarsOnSwipe = true
            background.isUserInteractionEnabled = true
            background.addGestureRecognizer(tap)
            background.addGestureRecognizer(swipe)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurateUI()
        viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stop()
        timeLabel.alpha = 0
        super.viewWillDisappear(animated)
    }
    
    func timerValueDidChange(_ new: String) {
        timeLabel.text = new
    }
    
    private func configurateUI() {
        timeLabel.loadTimerConfig()
        background.image = UIImage(named: Config.backgroundImageName)
        
        let position = Config.timerLabelPosition
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: .curveEaseOut,
                       animations: {
                        self.timeLabel.alpha = 1.0
                        self.vertical.constant = position.vertical
                        self.horizontal.constant = position.horizontal
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
}
