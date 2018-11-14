//
//  AppDelegate.swift
//  In2EventScan
//
//  Created by Admin on 2/24/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com")

    var connectionLostView: UIView! = nil
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        SideMenuManager.default.menuLeftNavigationController =
            STORYBOARD.instantiateViewController(withIdentifier: "SideMenu") as? UISideMenuNavigationController
        SideMenuManager.default.menuAnimationBackgroundColor = BACKGROUND_COLOR_1

        setupConnectionLostView()
        reachabilityManager?.listener = {status in
            switch status {
            case .notReachable:
                print("connection lost")
                self.showConnectionLostView()
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                Sync().syncCachedBarcodes()
                self.hideConnectionLostView()
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                Sync().syncCachedBarcodes()
                self.hideConnectionLostView()
            case .unknown:
                print("It is unknown whether the network is reachable")
                self.showConnectionLostView()
            }
        }
        
        reachabilityManager?.startListening()
        
        if(AppUserDefaults.isLoggedin){
            let scanVC = STORYBOARD.instantiateViewController(withIdentifier: "ScanVC")
            self.window?.rootViewController = UINavigationController(rootViewController: scanVC)
        }
        return true
    }
    
    func setupConnectionLostView() {
        var top: CGFloat = 20.0
        if #available(iOS 11.0, *) {
            top = self.window!.safeAreaInsets.top
        }
        let height = top + 44
        let rect = CGRect(x: 0, y: 0, width: self.window!.frame.width, height: height)
        self.connectionLostView = UIView(frame: rect)
        self.connectionLostView.backgroundColor = .red
        let lostLabel = UILabel(frame: CGRect(x: 60, y: top + 6, width: 320, height: 24))
        lostLabel.text = "Connection lost...".localized()
        lostLabel.textColor = .white
        lostLabel.font = UIFont(name: "Helvetica", size: 24)
        self.connectionLostView.addSubview(lostLabel)
    }
    
    func showConnectionLostView() {
        self.window!.addSubview(self.connectionLostView)
    }
    
    func hideConnectionLostView() {
        self.connectionLostView.removeFromSuperview()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

