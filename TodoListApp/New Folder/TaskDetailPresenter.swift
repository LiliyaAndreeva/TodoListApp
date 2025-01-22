//
//  TaskDetailPresenter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 20.01.2025.
//

import Foundation
protocol ITaskDetailsPresenter: AnyObject {
	func onViewDidLoad()
	func updateTask(_ task: TaskItem)
	func didUpdateTask(_ task: TaskItem)
}

final class TaskDetailsPresenter: ITaskDetailsPresenter {
	weak var view: ITaskDetailsViewController?
	private let interactor: ITaskDetailsInteractor
	private let router: ITaskDetailsRouter
	
	var task: TaskItem?
	
	init(
		view: ITaskDetailsViewController,
		interactor: ITaskDetailsInteractor,
		router: ITaskDetailsRouter
	) {
		self.view = view
		self.interactor = interactor
		self.router = router
	}
	
	
	func onViewDidLoad() {
		DispatchQueue.main.async{
			guard let task = self.task else { return }
			self.view?.updateTaskData(task)
		}
	}
	
	func updateTask(_ task: TaskItem) {
		interactor.updateTask(task)
	}
	func didUpdateTask(_ task: TaskItem) {
		view?.updateUI(with: task) // Передача обновленных данных в view
	}
}
