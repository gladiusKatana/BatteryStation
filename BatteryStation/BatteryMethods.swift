import Foundation; import MultipeerConnectivity

extension MCViewController {
    
    
    func trySendingBatteryData() {
        if mcSession.connectedPeers.count > 0 {
            let data = Data("Paired device's battery level:\n\(batteryLevel * 100)% [\(batteryStateString)]".utf8)
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let error as NSError {
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        } else { print("\nno connected peers\n") }
    }
    
    //temporary test method for testing with 2 simulators (as there is no battery data for simulators)
    func trySendingTestData() {
        if mcSession.connectedPeers.count > 0 {
            let data = Data("user hit Done on peer device".utf8)
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
        switch batteryState {
        case .unplugged, .unknown: batteryStateString = "not charging"
        case .charging: batteryStateString = "charging"
        case .full: batteryStateString = "full"
        @unknown default:
            //fatalError()
            batteryStateString = "UNKNOWN error with battery state" ; print("\n\(batteryStateString)\n")
        }
        trySendingBatteryData()
    }
    
}
