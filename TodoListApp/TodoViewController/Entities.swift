//
//  Entities.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation
struct TaskListResponse: Codable {
	let todos: [Task]
	let total: Int
	let skip: Int
	let limit: Int
}

struct Task: Codable {
	var id: Int
	var todo: String
	var description : String?
	var date: Date?
	var completed: Bool
	var userId: Int?

	init(
		id: Int,
		name: String,
		description: String,
		date: Date = Date(),
		isComplete: Bool = false,
		userId: Int? = nil
	) {
		self.id = id
		self.todo = name
		self.description = description
		self.date = date
		self.completed = isComplete
		self.userId = userId
	}
}
