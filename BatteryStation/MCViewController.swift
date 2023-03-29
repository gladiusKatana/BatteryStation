import UIKit; import SwiftUI; import MultipeerConnectivity

class MCViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    @AppStorage("settingActivated") var isHost_UserDefaultsSetting = true
    
    var peerID: MCPeerID! /// The peer ID is simply the name of the current device, which is useful for identifying who is joining a session.
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
    var mcBrowser: MCBrowserViewController?
    var batteryStateString = ""
    var batteryState: UIDevice.BatteryState { UIDevice.current.batteryState }
    var batteryLevel: Float { UIDevice.current.batteryLevel }
    var connectedPeers: Int { mcSession.connectedPeers.count }
    var statusView = StatusView(showConnectedPeers: .constant(false), connectedPeers: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad() //; view.backgroundColor = .red
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        //setupIDAndSession() /// if called here, browser dismissal via done/cancel will NOT trigger disconnection
    }
    
    override func viewWillAppear(_ animated: Bool) { print("viewWillAppear ... connected peers: \(mcSession != nil ? "\(connectedPeers)" : "[nil because mcSession is nil]")")
        super.viewWillAppear(animated)
        setupIDAndSession() // if called here, browser dismissal via done/cancel WILL trigger disconnection
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        if isHost_UserDefaultsSetting {
            let hostAction = UIAlertAction(title: "hosting session", style: .default)
            self.startHosting(action: hostAction)
        } else {
            let joinAction = UIAlertAction(title: "joining session", style: .default)
            self.joinSession(action: joinAction)
        }
        //guard let self = self else { return }
        setupStatusView()
        //}
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

