import Foundation; import SwiftUI; import MultipeerConnectivity

struct StatusView : View {
    
    var connectedPeers: [MCPeerID] = []
    var peerDictionary: [String:String] = [:]
    var connections: Int { connectedPeers.count }
    
    var body: some View {
        Form {
            let s = connections == 1 ? "" : "s"
            let cln = connections == 0 ? "" : ":"
            Text("\(connections) peer\(s) connected\(cln)")
            
            ForEach(connectedPeers, id: \.self) {
                let name = $0.displayName
                Text("\(name) \(peerDictionary[name] ?? "(nil value @ key \(name)")")
                    .foregroundColor(.blue)
            }
        }
        if connections < 6 { // 6 should be the limit as per MultipeerConnectivity framework
            Spacer()
            Form{
                Button("Tap to browse for more peers") {
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
        statusView = StatusView(connectedPeers: mcSession.connectedPeers, peerDictionary: peerDictionary)
        let childView = UIHostingController(rootView: statusView)
        childView.view.backgroundColor = .darkGray
        
        self.addChild(childView)
        childView.view.frame = self.view.bounds
        self.view.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
    
}
