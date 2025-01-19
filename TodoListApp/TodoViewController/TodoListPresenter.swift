//
//  TodoListPresenter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
protocol ITodoListPresenterProtocol: AnyObject {
	func viewDidLoad()
	func didSelectTask(_ task: TaskItem)
	func didFetchTasks(_ tasks: [TaskItem])
}

final class TodoListPresenter: ITodoListPresenterProtocol {
	weak var view: ITodoListViewController?
	private let interactor: ITodoListInteractor
	private let router: TodoListRouterProtocol
	
	init(
		view: ITodoListViewController,
		interactor: ITodoListInteractor,
		router: TodoListRouterProtocol
	) {
			self.view = view
			self.interactor = interactor
			self.router = router
		}
	
	func viewDidLoad() {
		interactor.fetchDataFromJson()
	}
	
	func didFetchTasks(_ tasks: [TaskItem]) {
		view?.displayTasks(tasks: tasks)
	}
	
	func didSelectTask(_ task: TaskItem) {
		interactor.updateTask(task: task)
	}
}
