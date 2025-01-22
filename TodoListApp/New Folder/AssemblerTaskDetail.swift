//
//  Assembler.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 22.01.2025.
//

import UIKit
final class AssemblerTaskDetail {
	
	static func build(with task: TaskItem) -> UIViewController {
		let storageManager = StorageManager.shared
		let taskManager = TaskManager(storageManager: storageManager)
		let view = TaskDetailsViewController()
		let router = TaskDetailsRouter()
		let interactor = TaskDetailsInteractor(
			storageManager: storageManager,
			taskmanager: taskManager
		)
		let presenter = TaskDetailsPresenter(
			view: view,
			interactor: interactor,
			router: router
		)

		view.presenter = presenter
		interactor.presenter = presenter
		presenter.view = view
		router.viewController = view

		presenter.task = task

		return view
	}
}
