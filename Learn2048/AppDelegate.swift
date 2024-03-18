//
//  AppDelegate.swift
//  Learn2048
//
//  Created by leitanglong on 2023/11/15.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var gameLogic: GameLogic!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.gameLogic = GameLogic()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("app did enter background")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("app will terminate")
    }
}

@main
struct SwiftUIDemoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            GameView().environmentObject(self.appDelegate.gameLogic)
        }
    }
}
