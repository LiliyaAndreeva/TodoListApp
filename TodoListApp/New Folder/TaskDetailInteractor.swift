//
//  TaskDetailInteractor.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 20.01.2025.
//

import Foundation
protocol ITaskDetailsInteractor {
	func updateTask(_ task: TaskItem)
}

final class TaskDetailsInteractor: ITaskDetailsInteractor {
	
	weak var presenter: ITaskDetailsPresenter?
	var taskList: [TaskItem] = []
	private let storageManager: IStorageManager
	private let taskmanager: ITaskManager
	
	init(
		storageManager: IStorageManager,
		taskmanager: ITaskManager
	) {
		self.storageManager = storageManager
		self.taskmanager = taskmanager
	}
	
	func updateTask(_ task: TaskItem) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else { return }
			self.storageManager.editTask(
				id: task.id,
				title: task.title,
				description: task.description ?? "",
				date: task.date ?? Date(),
				completed: task.isCompleted
			)
			DispatchQueue.main.async {
				self.presenter?.didUpdateTask(task) // Уведомляем презентер о завершении
			}
		}
	}
}
