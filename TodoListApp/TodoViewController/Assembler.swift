//
//  Assembler.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
final class Assembler {
	static func assemble() -> TodoListViewController {
		let networkManager = NetworkManager.shared
		let storageManager = StorageManager.shared
		let taskManager = TaskManager(storageManager: storageManager)
		
		let interactor = TodoListInteractor(
			networkmanager: networkManager,
			storageManager: storageManager,
			taskmanager: taskManager
		)
		let viewController = TodoListViewController()
		let router = TodoListRouter()
		let presenter = TodoListPresenter(
			view: viewController,
			interactor: interactor,
			router: router
		)

		viewController.presenter = presenter
		interactor.presenter = presenter
		
		presenter.view = viewController
		router.viewController = viewController

		return viewController
	}

}
