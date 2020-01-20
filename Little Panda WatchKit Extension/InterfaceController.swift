import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, TimerDelegate {

    @ViewModel var timerViewModel: TimerViewModel
    
    @IBOutlet weak var newYearLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        timerViewModel.delegate = self
        timerViewModel.start()
    }
    
    override func didDeactivate() {
        timerViewModel.stop()
        super.didDeactivate()
    }

    func timerValueDidChange(_ new: String) {
        newYearLabel.setText(new)
    }
}
