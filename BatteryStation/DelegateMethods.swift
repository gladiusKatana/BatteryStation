import Foundation; import MultipeerConnectivity

extension MCViewController {
    
    func session(_ session: MCSession,
                 didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        let str = String(decoding: data, as: UTF8.self)
        let components = str.components(separatedBy: "~")
        guard let key = components.first,
              let value = components.last else {
            return
        }
        
        /// iOS >= 16: to sort out duplication of peerIDs (ie to override default generic names), may require work w/ Apple on permissions ... see Documentation [will add link here]
//        if let _ = peerDictionary[key] {
//            print("\n\n! WILL OVERRIDE DUPLICATE DEVICE-NAME KEY'S VALUE IN PEERDICTIONARY")
//        }
        
        peerDictionary[key] = value
        
        DispatchQueue.main.async { [weak self] in self?.setupStatusView() }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        switch state {
        case .connecting:   print("\nConnecting: \(peerID.displayName)")
        case .notConnected: print("\nNot Connected: \(peerID.displayName)")
            DispatchQueue.main.async { [weak self] in self?.setupStatusView() }
        case .connected:    print("\nConnected: \(peerID.displayName) | connections: \(connections)\n")
            trySendingBatteryData()
        @unknown default:   print("\nUNKNOWN error in sessiondidChange: \(peerID.displayName)\n")
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}
