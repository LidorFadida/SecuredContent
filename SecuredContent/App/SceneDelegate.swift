//
//  SceneDelegate.swift
//  SecuredContent
//
//  Created by Lidor Fadida on 23/06/2024.
//

import UIKit
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let viewController = UIStoryboard(name: "InitialViewController", bundle: .main).instantiateInitialViewController()!
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
    }
}
