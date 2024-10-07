//
//  AppDelegate.swift
//  SpaceXLaunches
//
//  Created by Fábio Maciel de Sousa on 06.10.2024.
//

import Dependencies
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let launchesViewModel = withDependencies {
            $0.apiClient = .liveValue
        } operation: {
            LaunchesViewModel()
        }
        window?.rootViewController = UINavigationController(
            rootViewController: LaunchesViewController(viewModel: launchesViewModel)
        )
        window?.makeKeyAndVisible()
        return true
    }

}
