//
//  AppDelegate.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Load keys from JSON file
        if let path = Bundle.main.path(forResource: "secrets", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let keys = try JSONDecoder().decode(Keys.self, from: jsonData)

                // Store keys in Keychain
                APISecret.storeAPIKey(keys.publicKey)
                APISecret.storePrivateKey(keys.privateKey)
            } catch {
                fatalError("Error loading keys: \(error.localizedDescription)")
            }
        } else {
            fatalError("Keys file not found")
        }

        // Continue with app launch
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

