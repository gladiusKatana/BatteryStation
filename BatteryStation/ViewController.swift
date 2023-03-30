import UIKit; import SwiftUI; import MultipeerConnectivity

class MCViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID! /// The peer ID is simply the name of the current device, which is useful for identifying who is joining a session.
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController!
    var batteryStateString = ""
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }
    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var connectedPeers: Int { mcSession.connectedPeers.count }
    var statusView = StatusView(connectedPeers: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad() //; view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        browseForConnections(action: UIAlertAction(title: "joining session", style: .default))
        startAdvertising(action: UIAlertAction(title: "advertising session", style: .default))
    }
    
    override func viewWillAppear(_ animated: Bool) { print("viewWillAppear ... connected peers: \(mcSession != nil ? "\(connectedPeers)" : "[nil because mcSession is nil]")")
        super.viewWillAppear(animated)
        setupStatusView()
    }
    
    func setupIDAndSession(withDisplayName displayName: String) {
        peerID = MCPeerID(displayName: displayName)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        mcBrowser.delegate = self
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession) // _hws-kb._tcp
    }
    
    
    func browseForConnections(action: UIAlertAction!) {
        guard let mcBrowser = mcBrowser else { return }
        present(mcBrowser, animated: true)
    }
    
    func startAdvertising(action: UIAlertAction!) { //print("started advertising")
        mcAdvertiserAssistant.start()
    }
    
}

