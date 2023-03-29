import Foundation; import SwiftUI; import MultipeerConnectivity

struct StatusView : View {
    
    var connectedPeers = -1
    
    var body: some View {
        Form {
            let s = connectedPeers == 1 ? "" : "s"
            Text("\(connectedPeers) peer\(s) connected")
        }
    }

}

extension MCViewController {
    
    func setupStatusView() {
        statusView = StatusView(connectedPeers: self.connectedPeers)
        let childView = UIHostingController(rootView: statusView)
        childView.view.backgroundColor = .purple // should not see this though
        
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
