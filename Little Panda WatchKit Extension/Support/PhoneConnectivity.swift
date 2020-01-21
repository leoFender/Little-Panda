import WatchConnectivity
import Foundation

protocol PhoneConnectivityProvider: WCSessionDelegate {
    func askPhoneForUpdates()
}

class PhoneConnectivityService: NSObject, PhoneConnectivityProvider {
    
    private var session = WCSession.default
    
    override required init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .notActivated {
            print("PhoneConnectivity not activated. [WatchOS]")
        }
    }
    
    func session(_ session: WCSession,
                 didReceiveApplicationContext applicationContext: [String : Any]) {
        handleUpdatesResponse(applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handleUpdatesResponse(message)
    }
    
    func askPhoneForUpdates() {
        
        let message = [
            TransferModel.transferPandaKey: TransferModel.requestValue,
            TransferModel.transferComplicationKey: TransferModel.requestValue
        ]

        session.sendMessage(message,
                            replyHandler: { [weak self] response in
                                self?.handleUpdatesResponse(response)
        }, errorHandler: { error in
            print(error)
        })
    }
    
    private func handleUpdatesResponse(_ response: [String: Any]) {
        for key in response.keys {
            if key == TransferModel.transferComplicationKey,
                let index = response[key] as? NSNumber {
                
                WatchConfig.watchFaceTimerIndex = index.intValue
            }
            
            if key == TransferModel.transferPandaKey,
                let date = response[key] as? Date {
                
                WatchConfig.pandaAvailable = date
            }
        }
        
        WatchConfig.initialDataLoaded = true
        NotificationCenter.default.post(name: SharedConstants.updateUIWatchNotificationName,
                                        object: nil)
    }
}
