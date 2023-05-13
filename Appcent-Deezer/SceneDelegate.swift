//
//  SceneDelegate.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = scene as? UIWindowScene else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//
//        let homeViewController = FirstViewController()
//        let secondViewController = SecondViewController()
//
//        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
//        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
//
//        let tabBarController = UITabBarController()
//        tabBarController.viewControllers = [homeNavigationController, secondNavigationController]
//
//        // Customize the navigation bar appearance
//        tabBarController.tabBar.isTranslucent = false
//            tabBarController.tabBar.barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1.0)
//            tabBarController.tabBar.tintColor = .white
//
//            // Set the title and icon for each tab
//            homeNavigationController.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.note"), tag: 0)
//            secondNavigationController.tabBarItem = UITabBarItem(title: "Like", image: UIImage(systemName: "heart"), tag: 1)
//        // Set the tab bar controller as the root view controller
//        window.rootViewController = tabBarController
//        homeViewController.navigationItem.title = "Artists"
//
//
//        window.makeKeyAndVisible()
//
//        self.window = window
//
//
//        // Optionally, perform any additional configuration or setup here
//
//        // Save the window reference to a property if you need to access it later
//        // Example: self.window = window
//
//
//    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let homeViewController = FirstViewController()
        let secondViewController = SecondViewController()
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNavigationController, secondNavigationController]
        
        // Customize the tab bar appearance
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.tintColor = .systemPink
        
        if #available(iOS 13.0, *) {
            // Set the background color to adapt to the light and dark themes
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        } else {
            // Set the background color for earlier iOS versions
            tabBarController.tabBar.barTintColor = .systemPink
        }
        
        // Set the title and icon for each tab
        homeNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "music.note"), tag: 0)
        secondNavigationController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), tag: 1)
        
        // Customize tab bar item appearance
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .normal)
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .selected)
        
        // Set the tab bar controller as the root view controller
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        
        self.window = window
    
    }




    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

