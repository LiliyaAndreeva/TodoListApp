//
//  TodoListRouter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
	func navigateToTaskDetails(for task: TaskItem)
}

final class TodoListRouter: TodoListRouterProtocol {
	
	weak var viewController: UIViewController?
	
	func navigateToTaskDetails(for task: TaskItem) {
		let taskDetailsViewController = TaskDetailsModuleBuilder.build(with: task)
		viewController?.navigationController?.pushViewController(taskDetailsViewController, animated: true)
	}

}

final class TaskDetailsModuleBuilder {
	static func build(with task: TaskItem) -> UIViewController {
		let view = TaskDetailsViewController()
		let presenter = TaskDetailsPresenter()
		let interactor = TaskDetailsInteractor()
		let router = TaskDetailsRouter()

//		view.presenter = presenter
//		presenter.view = view
//		presenter.interactor = interactor
//		presenter.router = router
//		router.viewController = view
//		interactor.presenter = presenter
//
//		presenter.task = task

		return view
	}
}
