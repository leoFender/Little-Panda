import UIKit
import ChromaColorPicker

class ColorPickerViewController: BaseViewController {

    @IBOutlet weak var colorPicker: ChromaColorPicker!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var backgroundPreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Save",
                                         style: .plain,
                                         target: self,
                                         action: #selector(ColorPickerViewController.saveButtonDidTap))
        navigationItem.rightBarButtonItem = saveButton
        
        colorPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configurateUI()
    }
    
    private func configurateUI() {
        let currentFont = Config.timerFont
        let color = currentFont.rgbColor.uiColor()
        testLabel.textColor = color
        testLabel.font = UIFont(name: currentFont.name, size: currentFont.size)
        
//        backgroundPreview.image = UIImage(named: Config.backgroundImageName)
        
        colorPicker.adjustToColor(color)
    }
    
    @objc func saveButtonDidTap() {
        let current = Config.timerFont
        let rgb = testLabel.textColor.rgb()
        let newColor = ColorConfiguration(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
        let new = FontConfiguration(name: current.name, size: current.size, rgbColor: newColor)
        Config.timerFont = new

        navigationController?.popViewController(animated: true)
    }
}

extension ColorPickerViewController: ChromaColorPickerDelegate {
    
    @IBAction func colorValueDidChange(_ sender: ChromaColorPicker) {
        testLabel.textColor = sender.currentColor
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        testLabel.textColor = color
    }
}
