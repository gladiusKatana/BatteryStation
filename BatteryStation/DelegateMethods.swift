import Foundation; import MultipeerConnectivity

extension MCViewController {
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        ////trySendingBatteryData() /// !!!
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        ////trySendingBatteryData() /// !!!
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("\nConnected: \(peerID.displayName) ... connected peers: \(connectedPeers)\n")
            ///hostSetupStatusView()
            ///DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in self?.mcBrowser?.dismiss(animated: true) } /// !!!
        case MCSessionState.connecting: print("\nConnecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("\nNot Connected: \(peerID.displayName)")
            ///hostSetupStatusView()
        @unknown default:
            //fatalError()
            print("\nUNKNOWN error in sessiondidChange: \(peerID.displayName)\n")
        }
    }
    
    func session(_ session: MCSession,
                 didReceive data: Data, fromPeer peerID: MCPeerID) {
        let str = String(decoding: data, as: UTF8.self)
        let alert = UIAlertController(title: "Battery Level Update", message: str, preferredStyle: .alert)  // [\(connectedPeers) connected peers]
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { _ in // action in
            /*switch action.style {
             case .default: print("\n\nalert-tapped-OK--default\n\n")
             case .cancel: print("\n\nalert-tapped-OK--cancel\n\n")
             case .destructive: print("\n\nalert-tapped-OK--destructive")
             @unknown default:
             print("\nUNKNOWN error in session didReceive\n")
             fatalError()
             }*/
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        dismiss(animated: true)
    }
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
}
