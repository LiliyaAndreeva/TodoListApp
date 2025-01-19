//
//  TaskItem.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
import CoreData

final class TaskItem {
	let id: Int
	var title: String
	var description: String?
	var isCompleted: Bool
	var date: Date?
	var userId: Int?
	
	init(title: String, description: String? = nil, date: Date? = nil, completed: Bool = false, userId: Int? = nil, id: Int? = nil) {
		self.id = id ?? 0
		self.title = title
		self.description = description
		self.date = date
		self.isCompleted = completed
		self.userId = userId
	}
	
	init(from entity: TaskEntity) {
		self.id = Int(entity.id)
		self.title = entity.title ?? ""
		self.description = entity.description
		self.isCompleted = entity.isCompleted
		self.date = entity.date ?? Date()
	}
	
	init(from todoItem: Task) {
		self.id = todoItem.id
		self.title = todoItem.todo
		self.description = todoItem.description
		self.date = todoItem.date
		self.isCompleted = todoItem.completed
		self.userId = todoItem.userId
	}
}

extension TaskItem {
	func toEntity(in context: NSManagedObjectContext) -> TaskEntity {
		let entity = TaskEntity(context: context)
		entity.id = Int64(self.id)
		entity.title = self.title
		entity.taskDescription = self.description ?? ""
		entity.isCompleted = self.isCompleted
		entity.date = self.date
		return entity
	}

	func updateEntity(_ entity: TaskEntity) {
		entity.title = self.title
		entity.taskDescription = self.description ?? ""
		entity.isCompleted = self.isCompleted
		entity.date = self.date
	}
}

extension Array where Element == Task {
	func mapToTaskItems() -> [TaskItem] {
		return self.map { TaskItem(from: $0) }
	}
}
