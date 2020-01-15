import UIKit
import TYProgressBar

class PandaViewController: BaseViewController {

    @ViewModel var viewModel: PandaViewModel
    
    @IBOutlet weak var progressViewContainer: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var pandaLabel: UILabel!
    
    private var progressView = TYProgressBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurateUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PandaViewController.progressDidTap))
        progressViewContainer.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setupDelegate(self)
    }
    
    private func configurateUI() {
        let pandaFont = Config.pandaFont
        if let font = UIFont(name: pandaFont.name, size: 35.0) {
            pandaLabel.font = font
            progressView.font = font
        }
        
        progressView.frame = progressViewContainer.bounds
        progressViewContainer.addSubview(progressView)
        progressView.textColor = UIColor.systemPurple
        progressView.gradients = [UIColor.systemPurple, UIColor.systemPink]
        progressView.lineDashPattern = [3,2]
        progressView.lineHeight = 10
    }
    
    @objc private func progressDidTap() {
        if progressView.progress == 1 {
            viewModel.activatePanda()
        }
    }
    
    @IBAction func emergencyDidTap() {
        switch viewModel.checkEmergency() {
        case .available:
            showEmergencyAlert("Provide instatnt re-charge.\n\nWARNING! Emergency generator takes a long time to recharge.",
                               isActive: true,
                               activateAction: { [weak self] _ in
                                self?.viewModel.activateEmergency()
            },
                               viewController: self)
        case .charging(let message):
            showEmergencyAlert(message,
                               isActive: false,
                               viewController: self)
        }
    }
}

extension PandaViewController: PandaStateObserver {
    
    func didChangeState(_ new: PandaState) {
        switch new {
        case .inactive:
            progressView.progress = 1.0
            progressViewContainer.isHidden = false
            pandaLabel.isHidden = true
            loadingLabel.isHidden = true
            
        case .active(let text):
            progressViewContainer.isHidden = true
            loadingLabel.isHidden = true
            pandaLabel.text = text
            pandaLabel.isHidden = false
            
        case .charging(let value):
            pandaLabel.isHidden = true
            loadingLabel.isHidden = false
            progressViewContainer.isHidden = false
            progressView.progress = value
        }
    }
}
