//
//  StorageManager.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
import CoreData

protocol IStorageManager {
	func saveTask(id: Int, title: String, description: String, isCompleted: Bool, date: Date/*completion: (Task) -> Void*/)
	func fetchTasks() -> [TaskEntity]
	func editTask(id: Int, title: String, description: String, date: Date, completed: Bool)
	func deleteTask(_ task: TaskEntity)
	func saveTasks(taskItems: [TaskItem])
	func saveTasksToCoreData(tasks: [TaskItem])
}

final class StorageManager {
	static let shared = StorageManager()
	private let context: NSManagedObjectContext
	
	// MARK: - Core Data stack
	private var persistentContainer: NSPersistentContainer = {
		
		let container = NSPersistentContainer(name: "TodoListApp")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	
	private init(){
		self.context = persistentContainer.viewContext
	}
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}

extension StorageManager: IStorageManager {
	
	func saveTask(
		id: Int,
		title: String,
		description: String = "",
		isCompleted: Bool,
		date: Date
	) {
		let taskEntity = TaskEntity(context: context)
		taskEntity.id = Int64(id)
		taskEntity.title = title
		taskEntity.taskDescription = description
		taskEntity.isCompleted = isCompleted
		taskEntity.date = date
		saveContext()
	}
	
	func saveTasks(taskItems: [TaskItem]) {
		taskItems.forEach { taskItem in
			let taskEntity = TaskEntity(context: context)
			taskEntity.id = Int64(taskItem.id)
			taskEntity.title = taskItem.title
			taskEntity.taskDescription = taskItem.description ?? ""
			taskEntity.isCompleted = taskItem.isCompleted
			taskEntity.date = taskItem.date
			
		}
		saveContext()
		print("задачи успешно сохранены в coredata")
	}
	
	
	func fetchTasks() -> [TaskEntity] {
		let fetchRequest = TaskEntity.fetchRequest()
		do {
			let tasks = try context.fetch(fetchRequest)
			print("Загрузка данных из coreData успешна")
			return tasks
		} catch {
			print("Ошибка при загрузке задач из Core Data1: \(error)")
			return []
		}
	}
	
	func editTask(id: Int,
				  title: String,
				  description: String,
				  date: Date,
				  completed: Bool) {
		
		let fetchRequest = TaskEntity.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
		
		do {
			let result = try context.fetch(fetchRequest)
			if let taskEntity = result.first {
				taskEntity.title = title
				taskEntity.taskDescription = description
				taskEntity.date = date
				taskEntity.isCompleted = completed
				
				saveContext()
				print("Задача обновлена в Core Data: \(taskEntity)")
			}
		} catch {
			print("Ошибка при редактировании задачи в Core Data: \(error)")
		}
	}
	
	func deleteTask(_ task: TaskEntity) {
		context.delete(task)
		saveContext()
	}
	
	func saveTasksToCoreData(tasks: [TaskItem]/*, context: NSManagedObjectContext*/) {
		for taskItem in tasks {
			let _ = taskItem.toEntity(in: context)
		}
		do {
			try context.save()
		} catch {
			print("Error saving to Core Data: \(error)")
		}
	}
}
