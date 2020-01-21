import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, WatchTimerDelegate {

    @ViewModel var viewModel: InterfaceViewModel
    
    @IBOutlet weak var newYearLabel: WKInterfaceLabel!
    @IBOutlet weak var pandaRechargeLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        super.willActivate()
        viewModel.delegate = self
        viewModel.start()
    }
    
    override func didDeactivate() {
        viewModel.stop()
        super.didDeactivate()
    }

    func timerValueDidChange(_ new: String) {
        newYearLabel.setText(new)
    }
    
    func rechargeUpdated(_ new: String) {
        pandaRechargeLabel.setText(new)
    }
}
