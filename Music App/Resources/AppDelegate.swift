//
//  AppDelegate.swift
//  Music App
//
//  Created by Sơn Nguyễn on 09/07/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        if AuthManager.shared.isSignIn {
            AuthManager.shared.refreshAccessToken(completion: nil)
            window.rootViewController = TabBarViewController()
        } else {
            let navi = UINavigationController(rootViewController: WelcomeViewController())
            navi.navigationBar.prefersLargeTitles = true
            navi.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
            window.rootViewController = navi
        }
        
        window.makeKeyAndVisible()
        self.window = window
        AuthManager.shared.refreshAccessToken { success in
            print(success)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

