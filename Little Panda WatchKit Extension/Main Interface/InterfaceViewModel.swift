import Foundation

protocol WatchTimerDelegate: TimerDelegate {
    func rechargeUpdated(_ new: String)
}

class InterfaceViewModel: TimerViewModel {
    
    private var rechargeTimer: Timer?
    private var available = WatchConfig.pandaAvailable
    
    override func start() {
        super.start()
        
        rechargeTimer = Timer(timeInterval: 10.0, repeats: true, block: { [weak self] _ in
            self?.rechargeUpdate()
        })
        RunLoop.main.add(rechargeTimer!, forMode: RunLoop.Mode.common)
        rechargeUpdate()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(InterfaceViewModel.updateNotificationReceived),
                                               name: SharedConstants.updateUIWatchNotificationName,
                                               object: nil)
    }
    
    override func stop() {
        super.stop()
        rechargeTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateNotificationReceived() {
        available = WatchConfig.pandaAvailable
        rechargeUpdate()
    }
    
    private func rechargeUpdate() {
        guard let dlgt = delegate as? WatchTimerDelegate else {
            rechargeTimer?.invalidate()
            return
        }
        
        if !WatchConfig.initialDataLoaded {
            dlgt.rechargeUpdated("Loading...")
            return
        }
        
        let left = timeLeft()
        if left < 0 {
            dlgt.rechargeUpdated("100%")
            rechargeTimer?.invalidate()
        } else {
            let progress = Int(rechargeProgress(left) * 100)
            dlgt.rechargeUpdated("\(progress)%")
        }
    }
    
    private func timeLeft() -> TimeInterval {
        let now = Date()
        return available.timeIntervalSince(now)
    }
    
    private func rechargeProgress(_ timeLeft: TimeInterval) -> Double {
        return 1 - timeLeft / SharedConstants.rechargeTime
    }
}
