//
//  BatteryStation
//
//  Created by Gladius Katana on 2023-03-27.
//

import Foundation; import SwiftUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    @AppStorage("settingActivated") var peerIDDisplayName = ""
    var window: UIWindow?
    var mcVC = MCViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        if peerIDDisplayName == "" {
            peerIDDisplayName = UIDevice.current.name
        }
        mcVC.setupIDAndSession(withDisplayName: peerIDDisplayName)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .orange // should not appear if root view controller has a background color other than .clear
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: mcVC)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        mcVC.mcSession.disconnect()
    }

}

