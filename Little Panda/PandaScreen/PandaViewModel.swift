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
    
    @Injected var notifications: NotificationService
    @Injected var watchConnection: WatchConnectivityProvider

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
        expirationTimer = Timer(timeInterval: 12.0, repeats: false) { [weak self] _ in
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
        
        available = Date().plusXHours(x: 24)
        watchConnection.pushComplicationInfo(.pandaAvailableDate(available))
        Config.pandaAvailable = available
        if Config.pandaNotification {
            notifications.schedule(.panda)
        }
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
        available = Date.distantPast
        watchConnection.pushComplicationInfo(.pandaAvailableDate(available))
        Config.pandaAvailable = available
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
        return 1 - timeLeft / SharedConstants.rechargeTime
    }
    
    private func setupUpdateTimer() {
        updateTimer = Timer(timeInterval: 5, repeats: true) { [weak self] _ in
            self?.update()
        }
        
        RunLoop.main.add(updateTimer!, forMode: RunLoop.Mode.common)
    }
    
    private func expirePanda() {
        setupUpdateTimer()
        update()
    }
    
    private func releaseTimers() {
        updateTimer?.invalidate()
        expirationTimer?.invalidate()
    }
}
