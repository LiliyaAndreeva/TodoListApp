//
//  TodoListInteractor.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
protocol ITodoListInteractor: AnyObject {
	func fetchDataFromJson()
	func getTaskListCount() -> Int
	func updateTask(with id: Int)
	func removeTask(at indexPath: IndexPath)
	func shareTask(at indexPath: IndexPath)
}


final class TodoListInteractor: ITodoListInteractor {
	
	weak var presenter: ITodoListPresenterProtocol?
	var taskList: [TaskItem] = []
	var networkmanager: INetworkmanager?
	private let storageManager: IStorageManager
	private let taskmanager: ITaskManager
	
	
	init(
		networkmanager: INetworkmanager,
		storageManager: IStorageManager,
		taskmanager: ITaskManager
	) {
		self.networkmanager = networkmanager
		self.storageManager = storageManager
		self.taskmanager = taskmanager
	}
	
	
	
	func fetchDataFromJson() {
		loadTasksFromStorage()
		
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
						
						
						self.storageManager.saveTasks(taskItems: taskItems)
						self.presenter?.didFetchTasks(taskItems)
						
						DispatchQueue.main.async {
							self.presenter?.didFetchTasks(self.taskList)
							//self.viewController?.updateTaskList(tasks: self.taskList)
							print("Задачи загружены из Json")
						}
					}
				}
			)
		} else {
			DispatchQueue.main.async {
				// self.viewController?.updateTaskList(tasks: self.taskList)
				self.presenter?.didFetchTasks(self.taskList)
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
	
	func updateTask(with id: Int) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else { return }
			guard let index = taskList.firstIndex(where: { $0.id == id }) else { return }
			taskList[index].isCompleted.toggle() // Переключаем состояние
			
			let updatedTask = taskList[index]
			self.taskmanager.editTask(task: updatedTask) // Обновляем в TaskManager
			
			// Сохраняем в хранилище
			DispatchQueue.main.async {
				self.presenter?.didUpdateTask(updatedTask) // Уведомляем презентер
			}
		}
	}
	
	func getTaskListCount() -> Int {
		return taskList.count
	}
	func shareTask(at indexPath: IndexPath)
	{
		print("ShareTask button did tapped")
	}
	

	func removeTask(at indexPath: IndexPath) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			guard let self = self else { return }
			
			let task = self.taskList[indexPath.row]
			self.storageManager.deleteTask(withId: task.id)
			self.taskList.remove(at: indexPath.row)
			
			DispatchQueue.main.async {
				self.presenter?.didFetchTasks(self.taskList)
				print("Задача с id \(task.id) успешно удалена")
			}
		}
	}
}
