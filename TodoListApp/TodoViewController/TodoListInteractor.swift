//
//  TodoListInteractor.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
protocol ITodoListInteractor {
	func fetchDataFromJson()
	func updateTask(task: TaskItem)
}


final class TodoListInteractor: ITodoListInteractor {
	//var presenter:
	var taskList: [TaskItem] = []
	var networkmanager: INetworkmanager?
	private let storageManager: IStorageManager
	private let taskmanager: ITaskManager
	weak var viewController: ITodoListViewController?
	
	init(networkmanager: INetworkmanager, storageManager: IStorageManager, taskmanager: ITaskManager) {
		self.networkmanager = networkmanager
		self.storageManager = storageManager
		self.taskmanager = taskmanager
	}
	
	
	
	func fetchDataFromJson() {
		
		let taskEntities = storageManager.fetchTasks()
		taskList = taskEntities.map {$0.toModelTaskItem()}
		
		if taskList.isEmpty {
			
			networkmanager?.fetchData(
				url: URLs.startUrl,
				method: NetworkMethods.get,
				completion: { (response: TaskListResponse?, error: TaskListsErrors?) in
					if let error = error {
						print("Error fetching data: \(error.localizedDescription)")
						return
					}
					
					if let response = response {
						let taskItems = self.convertTasksToTaskItems(tasks: response.todos)
						self.taskList = taskItems
						print(self.taskList.last!.title)
						
						self.storageManager.saveTasks(taskItems: taskItems)
						//self.storageManager.saveTasksToCoreData(tasks: taskItems)
						
						DispatchQueue.main.async {
							self.viewController?.updateTaskList(tasks: self.taskList)
							print("Задачи загружены из Json")
						}
					}
				}
			)
		} else {
			DispatchQueue.main.async {
				  self.viewController?.updateTaskList(tasks: self.taskList)
				print("Задачи загружены из CoreData")
			  }
		}
		
	}
	
	func convertTasksToTaskItems(tasks: [Task]) -> [TaskItem] {
		return tasks.map { TaskItem(from: $0) }
	}
	
	private func loadTasksFromStorage() {
		let taskEntities = storageManager.fetchTasks()
		let taskItems: [TaskItem] = taskEntities.map {$0.toModelTaskItem()}
		self.taskList = taskItems
		
	}
	
	func updateTask(task: TaskItem) {
		taskmanager.editTask(task: task)
	}

}
