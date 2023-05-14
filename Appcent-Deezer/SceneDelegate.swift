//
//  SceneDelegate.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
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
        
        // Set the title and icon for each tab
        homeNavigationController.tabBarItem = UITabBarItem(title: "Music", image: UIImage(systemName: "music.note"), tag: 0)
        secondNavigationController.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart"), tag: 1)
        
        // Customize tab bar item appearance
        let tabBarItemAppearance = UITabBarItem.appearance()
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .normal)
        tabBarItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.systemPink], for: .selected)
        
        // Set the tab bar controller as the root view controller
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        
        self.window = window
    
    }


    lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "BHCoreData")
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent store \(error)")
                }
            }
            return container
        }()


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

