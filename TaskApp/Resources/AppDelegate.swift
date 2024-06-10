//
//  AppDelegate.swift
//  TaskApp
//
//  Created by Nilgul Cakir on 2.06.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: QRScannerVC())
        window?.makeKeyAndVisible()
        return true
    }
}



