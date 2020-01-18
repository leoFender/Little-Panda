import UIKit

class SettingsViewController: BaseTableViewController {
    private var fontConfigCurrentScreen: Screens = .timer
    
    @ViewModel var viewModel: SettingsViewModel
    
    @IBOutlet weak var timerFontLabel: UILabel!
    @IBOutlet weak var pandaFontLabel: UILabel!
    @IBOutlet weak var timerNotificationSwitch: UISwitch!
    @IBOutlet weak var pandaNotificationSwitch: UISwitch!
    @IBOutlet weak var timerBackgroundLabel: UILabel!
    @IBOutlet weak var fontSizeStepper: UIStepper!
    @IBOutlet weak var fontSizeLabel: UILabel!
    @IBOutlet weak var fontColor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configurateUI()
    }
    
    private func presentFontSelector() {
        let selectorController = UIFontPickerViewController()
        selectorController.delegate = self

        present(selectorController, animated: true, completion: nil)
    }
    
    private func configurateUI() {
        let currentTimerFont = Config.timerFont
        fontColor.textColor = currentTimerFont.rgbColor.uiColor()
        fontColor.dropShadow()
        timerFontLabel.text = currentTimerFont.name
        fontSizeLabel.text = "\(Int(currentTimerFont.size))"
        fontSizeStepper.value = Double(currentTimerFont.size)
        
        let currentPandaFont = Config.pandaFont
        pandaFontLabel.text = currentPandaFont.name
        
        timerNotificationSwitch.isOn = Config.timerNotification
        pandaNotificationSwitch.isOn = Config.pandaNotification
        
        timerBackgroundLabel.text = Config.backgroundImageName
    }
}

extension SettingsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            timerSettingDidSelect(indexPath.row)
        default:
            pandaSettingDidSelect(indexPath.row)
        }
    }
    
    private func timerSettingDidSelect(_ index: Int) {
        switch index {
            
        case 0: // font
            fontConfigCurrentScreen = .timer
            presentFontSelector()
        case 2: // font color
            router.show(.colorSelection, from: self)
        case 3: // background
            router.show(.backgroundSelection, from: self)
        case 4: // timer poisiton
            router.show(.layoutSetup, from: self)
        default:
            return
        }
    }
    
    private func pandaSettingDidSelect(_ index: Int) {
        switch index {
        case 0: // font
            fontConfigCurrentScreen = .panda
            presentFontSelector()
        default:
            return
        }
    }
}

extension SettingsViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
        
        if let descriptor = viewController.selectedFontDescriptor {
            let font = UIFont(descriptor: descriptor, size: 25.0)
            viewModel.newFontSelected(font, for: fontConfigCurrentScreen)
            configurateUI()
        }
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController {
    
    @IBAction func stepperValueDidChange(_ sender: UIStepper) {
        viewModel.newSizeSelected(CGFloat(sender.value))
        configurateUI()
    }
    
    @IBAction func pandaNotificationSwitchValueDidChange(_ sender: UISwitch) {
        viewModel.toggleNotifications(.panda) { [weak self] in
            DispatchQueue.main.async {
                self?.configurateUI()
            }
        }
    }
    
    @IBAction func timerNotificationSwitchValueDidChange(_ sender: UISwitch) {
        viewModel.toggleNotifications(.timer) { [weak self] in
            DispatchQueue.main.async {
                self?.configurateUI()
            }
        }
    }
}
