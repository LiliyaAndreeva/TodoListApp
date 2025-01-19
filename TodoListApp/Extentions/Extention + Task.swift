//
//  Extention + Task.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
import CoreData

extension Task {
	func toTaskEntity(in context: NSManagedObjectContext) -> TaskEntity {
		let taskEntity = TaskEntity(context: context)
		taskEntity.id = Int64(id)
		taskEntity.title = todo
		taskEntity.taskDescription = description
		taskEntity.date = date
		taskEntity.isCompleted = completed
		taskEntity.userId = Int64(userId ?? 0)
		return taskEntity
	}
}
