//
//  SceneDelegate.swift
//  VirusSimulator-ios
//
//  Created by Aleksey Kolesnikov on 22.03.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let paramsViewController = ParamsViewController()
        window.rootViewController = UINavigationController(rootViewController: paramsViewController)
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

