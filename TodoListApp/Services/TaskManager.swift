//
//  TaskManager.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
protocol ITaskManager {

	/// Добавление нового задания.
	/// - Parameter task: Задание.
	func addTask(task: TaskItem)

	/// Удаление задания из списка. При вызове метода будут удалены все варианты этого задания по идентичности Task.
	/// - Parameter task: Задание, которое необходимо удалить.
	func removeTask(task: TaskItem)
	/// Редактирвоание задачи.
	/// - Parameter task: Задание, которое необходимо редактировать.
	func editTask(task: TaskItem)
}

final class TaskManager: ITaskManager {
	
	/*private */var taskList = [TaskItem]()
	private let storageManager: IStorageManager
	
	
	init(storageManager: IStorageManager) {
		self.storageManager = storageManager
	}

	/// Добавление нового задания.
	func addTask(task: TaskItem) {
		taskList.append(task)
		storageManager.saveTask(
			id: task.id ,
			title: task.title ,
			description: task.description ?? "",
			isCompleted: task.isCompleted,
			date: task.date ?? Date()
		)
	}
	
	/// Удаление задания из списка
	func removeTask(task: TaskItem) {
		
		taskList.removeAll { $0.id == task.id }
		storageManager.deleteTask(withId: task.id)
	}
	
	/// Редактировние  задания из списка
	func editTask(task: TaskItem) {
		if let index = taskList.firstIndex(where: { $0.id == task.id }) {
			taskList[index] = task
		}
		
		storageManager.editTask(
			id: task.id,
			title: task.title,
			description: task.description ?? "",
			date: task.date ?? Date(),
			completed: task.isCompleted
		)
			
	}
}
