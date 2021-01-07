//
//	NoteThat : AppDelegate.swift by Tymek on 05/10/2020 15:16.
//	Copyright ©Tymek 2020. All rights reserved.


import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print((Realm.Configuration.defaultConfiguration.fileURL)!)
        do {
            _ = try Realm()
        } catch {
            print("Error while triggering Realm: \(error)")
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
}

