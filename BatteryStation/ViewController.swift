import UIKit; import SwiftUI; import MultipeerConnectivity

class MCViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var peerID: MCPeerID! /// The peer ID is simply the name of the current device, which is useful for identifying who is joining a session.
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController?
    var batteryStateString = ""
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }
    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var connectedPeers: Int { mcSession.connectedPeers.count }
    var statusView = StatusView(connectedPeers: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad() //; view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        setupIDAndSession()
        let hostAction = UIAlertAction(title: "hosting session", style: .default)
        self.startHosting(action: hostAction)
        let joinAction = UIAlertAction(title: "joining session", style: .default)
        self.joinSession(action: joinAction)
    }
    
    override func viewWillAppear(_ animated: Bool) { print("viewWillAppear ... connected peers: \(mcSession != nil ? "\(connectedPeers)" : "[nil because mcSession is nil]")")
        super.viewWillAppear(animated)
        setupStatusView()
    }
    
    private func setupIDAndSession() {
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func startHosting(action: UIAlertAction!) { //print("starting hosting")
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-kb", discoveryInfo: nil, session: mcSession) // _hws-kb._tcp
        mcAdvertiserAssistant.start()
    }
    
    func joinSession(action: UIAlertAction!) {
        mcBrowser = MCBrowserViewController(serviceType: "hws-kb", session: mcSession)
        guard let mcBrowser = mcBrowser else { return }
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
}

