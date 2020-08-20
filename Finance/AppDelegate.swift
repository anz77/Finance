//
//  AppDelegate.swift
//  Finance
//
//  Created by Andrii Zuiok on 18.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    let defaultLists = [
        SymbolsList(name: "EQUITIES", symbolsArray: ["AAPL", "GOOG", "FB", "AMZN"], isActive: true),
        SymbolsList(name: "CRYPTOCURRENCIES", symbolsArray: ["BTC-USD"], isActive: true),
        //SymbolsList(name: "CURRENCIES", symbolsArray: ["EURUSD=X"], isActive: true),
        SymbolsList(name: "INDEXES", symbolsArray: ["^DJI", "^GSPC"], isActive: true),
        //SymbolsList(name: "FUTURES", symbolsArray: ["GC=F"], isActive: true)
    ]
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        
        //defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")

        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            //debugPrint("App already launched sometimes")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //debugPrint("App launched first time")
            return false
        }
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if !isAppAlreadyLaunchedOnce() { storeDefaultsFromSymbolLists(defaultLists) }
        //storeDefaultsFromSymbolLists(defaultLists)
    
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

