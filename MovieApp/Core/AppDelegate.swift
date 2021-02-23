//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 24/02/21.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let homeViewController = HomeViewController()
        let appUINavController = UINavigationController(rootViewController: homeViewController)
        
        window?.rootViewController = appUINavController
        window?.makeKeyAndVisible()
        
        return true
    }

}

