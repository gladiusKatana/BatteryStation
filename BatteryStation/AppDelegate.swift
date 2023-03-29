//
//  BatteryStation
//
//  Created by Gladius Katana on 2023-03-27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mcVC = MCViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .orange // should not appear if root view controller has a background color other than .clear
        window?.makeKeyAndVisible()
        
        window?.rootViewController = UINavigationController(rootViewController: mcVC)
        return true
    }

//    func applicationWillResignActive(_ application: UIApplication) {
////        print("[applicationWillResignActive] battery level: \(mcVC.batteryLevel)\nbattery state: \(mcVC.batteryState)")
//        let batteryState = UIDevice.current.batteryState
//        let batteryLevel = UIDevice.current.batteryLevel
//        print("\n[applicationWillResignActive] battery level: \(batteryLevel)\nbattery state: \(batteryState)")
//    }
}

