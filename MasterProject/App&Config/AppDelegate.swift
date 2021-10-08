//
//  AppDelegate.swift
//  MasterProject
//
//  Created by Carlos Colmenares on 31/07/2020.
//  Copyright © 2020 Carlos Colmenares. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {

    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

