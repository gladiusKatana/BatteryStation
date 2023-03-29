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
    
    func session(_ session: MCSession, peer peerID: MCPeerID,
                 didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("\nConnected: \(peerID.displayName) ... connected peers: \(connectedPeers)\n")
            hostSetupStatusView()
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) { [weak self] in // !!!
             self?.mcBrowser?.dismiss(animated: true)
             }*/
        case MCSessionState.connecting: print("\nConnecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("\nNot Connected: \(peerID.displayName)")
            hostSetupStatusView()
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
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        dismiss(animated: true)
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        dismiss(animated: true)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        ////trySendingBatteryData() /// !!!
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        ////trySendingBatteryData() /// !!!
        dismiss(animated: true)
    }
    
    func hostSetupStatusView() {
        DispatchQueue.main.async() { [unowned self] in
            if self.isHost_UserDefaultsSetting {
                setupStatusView()
            }
        }
    }
    
    func setupStatusView() {
        statusView = StatusView(showConnectedPeers: self.$isHost_UserDefaultsSetting, connectedPeers: self.connectedPeers)
        let childView = UIHostingController(rootView: statusView)
        childView.view.backgroundColor = .purple // should not see this though
        
        self.addChild(childView)
        childView.view.frame = self.view.bounds
        self.view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}

struct StatusView : View {
    @AppStorage("settingActivated") var isHost_UserDefaultsSetting = true
    @Binding var showConnectedPeers : Bool
    
    var connectedPeers = -1
    
    var body: some View {
        Form {
            
            Toggle("is host device?", isOn: $isHost_UserDefaultsSetting)
                .onChange(of: isHost_UserDefaultsSetting) { value in // print("\nupdated isHost setting to \(value) ... \n")
                    
                    ///if !showConnectedPeers {
                    refreshRootViewController()
                    ///}
                    
                }
                .tint(.orange)
            
            if showConnectedPeers {
                let s = connectedPeers == 1 ? "" : "s"
                Text("\(connectedPeers) peer\(s) connected")
            } else {
                Text("scanning for peers")
            }
            
        }
    }
    
    func refreshRootViewController() { print("\nrefreshing view controller")
        if let apdel = UIApplication.shared.delegate as? AppDelegate,
           let window = apdel.window {
            window.rootViewController = UINavigationController(rootViewController: apdel.mcVC)
        } else {
            print("\n\nAPP DELEGATE DOWNCAST FAILURE\n\n")
        }
    }
}

