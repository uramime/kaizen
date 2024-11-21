//
//  AppDelegate.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Create the window
//        window = UIWindow(frame: UIScreen.main.bounds)
//                
//        // Create an instance of YourViewController
//        let viewController = ViewController()
//        
//        // Create a UINavigationController with yourViewController as the root view controller
//        let navigationController = UINavigationController(rootViewController: viewController)
//        
//        // Set the root view controller to the navigation controller
//        window?.rootViewController = navigationController
//        
//        // Make the window visible
//        window?.makeKeyAndVisible()
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

