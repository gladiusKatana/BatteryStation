import UIKit; import MultipeerConnectivity

extension MCViewController {
    
    func trySendingBatteryData() {
        if mcSession.connectedPeers.count > 0 {
            let data = Data("\(UIDevice.current.name)\(componentSeparator) (\(batteryLevel * 100)%, \(batteryStateName))".utf8) /// * replace UIDevice.current.name w/  peerIDDisplayName
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else { print("\nno connected peers\n") }
    }
    
    
    @objc func batteryLevelDidChange(_ notification: Notification) { //print("\n\nBATTERY LEVEL:\n\(batteryLevel * 100)\n")
        trySendingBatteryData()
    }
    
    
    @objc func batteryStateDidChange(_ notification: Notification) {
        trySendingBatteryData()
    }
    
}

