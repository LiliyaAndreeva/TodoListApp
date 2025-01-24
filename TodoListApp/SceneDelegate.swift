//
//  SceneDelegate.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		let navigationController = Assembler.assembleNavigationController()
		
		let window = UIWindow(windowScene: scene)

		window.rootViewController = navigationController
		window.overrideUserInterfaceStyle = .dark
		window.makeKeyAndVisible()
		self.window = window

	}
}

