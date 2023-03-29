import Foundation; import SwiftUI; import MultipeerConnectivity

extension MCViewController {
    
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
