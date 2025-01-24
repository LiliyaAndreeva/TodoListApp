//
//  TodoListPresenter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
protocol ITodoListPresenterProtocol: AnyObject {

	func viewDidLoad()
	func toggleTaskCompletion(taskId: Int)
	func didSelectTask(_ task: TaskItem)
	func shareTask(at indexPath: IndexPath)
	func addNewTask()
	
	func didFetchTasks(_ tasks: [TaskItem])
	func didUpdateTask(_ task: TaskItem)
	func editTask(_ task: TaskItem)
	func deleteTask(at indexPath: IndexPath)
	func didEditTask(_ task: TaskItem)
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

	func shareTask(at indexPath: IndexPath) {
		interactor.shareTask(at: indexPath)
	}
	
	func viewDidLoad() {
		interactor.fetchDataFromJson()
	}
	
	func didFetchTasks(_ tasks: [TaskItem]) {
		view?.displayTasks(tasks: tasks)
	}
	
	func didSelectTask(_ task: TaskItem) {
		router.navigateToTaskDetails(for: task)
	}
	func addNewTask() {
		let newTask = TaskItem(
			title: "Введите название задачи",
			description: "Введите описание задачи",
			date: Date(),
			completed: false,
			id: Int(Date().timeIntervalSince1970)
		)
		interactor.addTask(newTask)
		router.navigateToTaskDetails(for: newTask)
	}

	//обновление статуса в ячейке
	func toggleTaskCompletion(taskId: Int) {
		interactor.updateTask(with: taskId)
	}

	func didUpdateTask(_ task: TaskItem) {
		view?.updateTask(task)
	}


	func editTask(_ task: TaskItem) {
		interactor.updateTask(with: task.id)
	}
	
	func didEditTask(_ task: TaskItem) {
		view?.updateTask(task)
	}
	
	func deleteTask(at indexPath: IndexPath) {
		interactor.removeTask(at: indexPath)
	}

}
