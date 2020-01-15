import Foundation

protocol PandaStateObserver: AnyObject {
    func didChangeState(_ new: PandaState)
}

enum PandaState {
    case inactive
    case active(String)
    case charging(Double)
}

enum EmergencyState {
    case available
    case charging(String)
}

class PandaViewModel {
    
    private static let rechargeTime: TimeInterval = 86400
    private var available = Config.pandaAvailable
    private weak var delegate: PandaStateObserver?
    private var updateTimer: Timer?
    private var expirationTimer: Timer?
    
    deinit {
        releaseTimers()
    }
    
    func setupDelegate(_ object: PandaStateObserver) {
        releaseTimers()
        
        delegate = object
        setupUpdateTimer()
        update()
    }
    
    func activatePanda() {
        expirationTimer = Timer(timeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.expirePanda()
        }
        RunLoop.main.add(expirationTimer!, forMode: RunLoop.Mode.common)
        
        let index = Config.lastPandaEntry + 1
        var entry = ""
        if index < Strings.PandaList.count {
            entry = Strings.PandaList[index]
            Config.lastPandaEntry = index
        } else {
            entry = Strings.PandaList[0]
            Config.lastPandaEntry = 0
        }
        
        let newState = PandaState.active(entry)
        delegate?.didChangeState(newState)
    }
    
    func checkEmergency() -> EmergencyState {
        let emergencyReactivated = Config.emergencyAvailable
        let timeLeft = emergencyReactivated.timeIntervalSince(Date())
        if timeLeft > 0 {
            if timeLeft < 3600 {
                return .charging("Emergency generator re-charging.\n\nTime left: <1h")
            }
            let hours = Int(timeLeft / 3600)
            return .charging("Emergency generator re-charging.\n\nTime left: \(hours)h")
        }
        
        return .available
    }
    
    func activateEmergency() {
        releaseTimers()
        delegate?.didChangeState(.inactive)
        Config.emergencyAvailable = Date().plusXHours(x: 72)
    }
    
    private func update() {
        let left = timeLeft()
        if left > 0 {
            let newState = PandaState.charging(rechargeProgress(timeLeft()))
            delegate?.didChangeState(newState)
        } else {
            updateTimer?.invalidate()
            delegate?.didChangeState(.inactive)
        }
    }
    
    private func timeLeft() -> TimeInterval {
        let now = Date()
        return available.timeIntervalSince(now)
    }
    
    private func rechargeProgress(_ timeLeft: TimeInterval) -> Double {
        return 1 - timeLeft / PandaViewModel.rechargeTime
    }
    
    private func setupUpdateTimer() {
        updateTimer = Timer(timeInterval: 5, repeats: true) { [weak self] _ in
            self?.update()
        }
        
        RunLoop.main.add(updateTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func expirePanda() {
        available = Date().plusXHours(x: 24)
        Config.pandaAvailable = available
        setupUpdateTimer()
        update()
    }
    
    private func releaseTimers() {
        updateTimer?.invalidate()
        expirationTimer?.invalidate()
    }
}
