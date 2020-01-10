import Foundation

protocol TimerDelegate: AnyObject {
    func timerValueDidChange(_ new: String)
}

class TimerViewModel {
    var timerStringValue: String = ""
    var timer: Timer?
    
    weak var delegate: TimerDelegate?
    
    private var days: TimeInterval = 0
    private var seconds: TimeInterval = 0
    
    func start() {
        days = -Date.daysToNewYear()
        seconds = -Date.secondsToNewYear()
        timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.update()
        })
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func update() {
        seconds -= 1
        if seconds < 0 {
            days = -Date.daysToNewYear()
            seconds = -Date.secondsToNewYear()
        }
        let daysString = DateComponentsFormatter.daysString(from: days)
        let secondsString = DateComponentsFormatter.hoursString(from: seconds)
        
        delegate?.timerValueDidChange(composeText(daysString, seconds: secondsString))
    }
    
    private func composeText(_ days: String, seconds: String) -> String {
        return "\(days)\n\(seconds)"
    }
}
