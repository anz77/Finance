//
//  SceneDelegate.swift
//  inance
//
//  Created by Andrii Zuiok on 18.05.2020.
//  Copyright © 2020 Andrii Zuiok. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private(set) static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        Self.shared = self
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let internetChecker = InternetConnectionManager.isConnectedToNetwork()
            let mainViewModel = MainViewModel(from: getDefaultLists(), internetChecker: internetChecker)
            let mainView = MainView(mainViewModel: mainViewModel).environmentObject(mainViewModel)
            
            //window.overrideUserInterfaceStyle = .dark
            
            let style = UserDefaults.standard.integer(forKey: "LastStyle")
            window.overrideUserInterfaceStyle = (style == 0 ? .dark : UIUserInterfaceStyle(rawValue: style)!)
            
            window.rootViewController = UIHostingController(rootView: mainView)
            
            self.window = window
            
            window.makeKeyAndVisible()
            
        }
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        //debugPrint("sceneDidDisconnect")
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        //debugPrint("sceneDidBecomeActive")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        //debugPrint("sceneWillResignActive")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        //debugPrint("sceneWillEnterForeground")
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        //debugPrint("sceneDidEnterBackground")
    }
    
    
}

