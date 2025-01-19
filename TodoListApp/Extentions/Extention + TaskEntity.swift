//
//  Extention + TaskEntity.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
import CoreData

extension TaskEntity {
	func toModel() -> Task {
		let taskId = Int(self.id)
		let taskName = self.title ?? "Untitled Task"
		let taskDescription = self.taskDescription ?? ""
		let taskDate = self.date ?? Date()
		let taskCompleted = self.isCompleted
		let taskUserId = self.userId != 0 ? Int(self.userId) : nil

		return Task(
			id: taskId,
			name: taskName,
			description: taskDescription,
			date: taskDate,
			isComplete: taskCompleted,
			userId: taskUserId
		)
	}
	
	func toModelTaskItem() -> TaskItem {
		let taskId = Int(self.id)  
		let taskTitle = self.title ?? "Untitled Task"
		let taskDescription = self.taskDescription ?? ""
		let taskDate = self.date ?? Date()
		let taskCompleted = self.isCompleted
		let taskUserId = self.userId != 0 ? Int(self.userId) : nil
		
		return TaskItem(
			title: taskTitle,
			description: taskDescription,
			date: taskDate,
			completed: taskCompleted,
			userId: taskUserId,
			id: taskId
		)
	}
}
