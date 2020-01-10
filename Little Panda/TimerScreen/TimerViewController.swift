import UIKit

class TimerViewController: BaseViewController, TimerDelegate {

    @ViewModel var viewModel: TimerViewModel
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        UIView.animate(withDuration: 1.0,
                       delay: 1.0,
                       options: .curveEaseOut,
                       animations: {
                        self.timeLabel.alpha = 1.0
        },
                       completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stop()
        super.viewWillDisappear(animated)
    }
    
    func timerValueDidChange(_ new: String) {
        timeLabel.text = new
    }
}
