import Foundation; import SwiftUI; import MultipeerConnectivity

struct StatusView : View {
    
    var connectedPeers = -1
    var peerDisplayNames = [String]()
    
    var body: some View {
        Form {
            let s = connectedPeers == 1 ? "" : "s"
            let cln = connectedPeers == 0 ? "" : ":"
            Text("\(connectedPeers) peer\(s) connected\(cln)")
            
            ForEach(peerDisplayNames, id: \.self) {
                Text($0)
                    .foregroundColor(.blue)
            }
        }
        if connectedPeers < 6 { // 6 should be the limit as per MultipeerConnectivity framework
            Spacer()
            Form{
                Button("Tap to browse for more peers") {
                    //print("button pressed")
                    if let apdel = UIApplication.shared.delegate as? AppDelegate {
                        apdel.mcVC.present(apdel.mcVC.mcBrowser, animated: true)
                    } else {
                        print("\n\nAPP DELEGATE DOWNCAST FAILURE\n\n")
                    }
                }
            }
        }
    }
    
}

extension MCViewController {
    
    func setupStatusView() {
        let displayNames = mcSession.connectedPeers.map{$0.displayName}
        statusView = StatusView(connectedPeers: self.connectedPeers, peerDisplayNames: displayNames)
        let childView = UIHostingController(rootView: statusView)
        childView.view.backgroundColor = .blue // should not see this though
        
        self.addChild(childView)
        childView.view.frame = self.view.bounds
        self.view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    
//    func hostSetupStatusView() {
//        DispatchQueue.main.async() { [unowned self] in
//            ///if self.isHost_UserDefaultsSetting {
//                setupStatusView()
//            ///}
//        }
//    }
}
