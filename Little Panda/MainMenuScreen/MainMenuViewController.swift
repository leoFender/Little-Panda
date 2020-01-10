import UIKit

final class MainMenuViewController: BaseViewController {

    @ViewModel var viewModel: MainMenuViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pandaDidTap() {
        router.show(.panda, from: self)
    }
    
    @IBAction func settingsDidTap() {
        router.show(.settings, from: self)
    }
    
    @IBAction func timerDidTap() {
        router.show(.timer, from: self)
    }
}
