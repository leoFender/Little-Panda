import Foundation
import WatchConnectivity

protocol WatchConnectivityProvider: NSObject, WCSessionDelegate {
    func send(_ model: TransferModel)
    func pushComplicationInfo(_ model: TransferModel)
}

class WatchConnectivityService: NSObject, WatchConnectivityProvider, WCSessionDelegate {
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {}
    
    private var session: WCSession?
    private var validSession: WCSession? {
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    override required init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .notActivated {
            print(error ?? "WatchConnectivity session is not activated")
        }
    }
    
    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {
        
        var response: [String: Any] = [:]
        if message.keys.contains(TransferModel.transferPandaKey) {
            let date = Config.pandaAvailable
            response[TransferModel.transferPandaKey] = date as NSDate
        }
        
        if message.keys.contains(TransferModel.transferComplicationKey) {
            let index = Config.watchFaceTimerIndex
            response[TransferModel.transferComplicationKey] = NSNumber(integerLiteral: index)
        }
        
        replyHandler(response)
    }
    
    func send(_ model: TransferModel) {
        guard let activeSession = validSession else {
            print("Cannot transfer data. Session is invalid")
            return
        }
        
        if activeSession.isReachable {
            activeSession.sendMessage([model.key: model.transferValue()],
                                      replyHandler: nil) { error in
                                        print(error)
            }
            return
        }
        
        do {
            try activeSession.updateApplicationContext([model.key: model.transferValue()])
        } catch {
            print(error)
        }
    }
    
    func pushComplicationInfo(_ model: TransferModel) {
        guard let activeSession = validSession else {
            print("Cannot transfer data. Session is invalid")
            return
        }
        
        if activeSession.remainingComplicationUserInfoTransfers == 0 ||
            activeSession.isComplicationEnabled ||
            activeSession.isReachable {
            send(model)
        }
        
        activeSession.transferCurrentComplicationUserInfo([model.key: model.transferValue()])
    }
}
