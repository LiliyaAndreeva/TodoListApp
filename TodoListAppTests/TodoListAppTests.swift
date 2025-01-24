//
//  TodoListAppTests.swift
//  TodoListAppTests
//
//  Created by Лилия Андреева on 19.01.2025.
//

import XCTest
@testable import TodoListApp


final class TodoListAppTests: XCTestCase {
	var taskManager: TaskManager!
	var mockStorageManager: MockStorageManager!
	
	
	override func setUpWithError() throws {
		super.setUp()
		mockStorageManager = MockStorageManager()
		taskManager = TaskManager(storageManager: mockStorageManager)
	}

    override func tearDownWithError() throws {
		taskManager = nil
		mockStorageManager = nil
		super.tearDown()
	}

	func testAddTask() throws {
		// Arrange
		let task = TaskItem(
			title: "Test Task",
			description: "Describtion",
			date: Date(),
			completed: false,
			id: 1
		)
		
		// Act
		taskManager.addTask(task: task)
		
		// Assert
		XCTAssertTrue(mockStorageManager.saveTaskCalled, "Метод saveTask должен быть вызван")
		XCTAssertEqual(mockStorageManager.savedTask?.id, task.id, "Добавленная задача должна иметь корректный id")
		XCTAssertEqual(taskManager.taskList.count, 1, "Список задач должен содержать одну задачу")
	}
	
	func testRemoveTask() throws {
		// Arrange
		let task = TaskItem(
			title: "Test Task",
			description: "Describtion",
			date: Date(),
			completed: false,
			id: 1
		)
		taskManager.addTask(task: task)
		
		// Act
		taskManager.removeTask(task: task)
		
		// Assert
		XCTAssertTrue(mockStorageManager.deleteTaskWithIdCalled, "Метод deleteTask должен быть вызван")
		XCTAssertEqual(mockStorageManager.deletedTaskId, task.id, "Удалённая задача должна иметь корректный id")
		XCTAssertTrue(taskManager.taskList.isEmpty, "Список задач должен быть пустым после удаления")
	}
	
	func testEditTask() throws {
		// Arrange
		let task = TaskItem(
			title: "Test Task",
			description: "Describtion",
			date: Date(),
			completed: false,
			id: 1
		)
		let updatedTask = TaskItem(
			title: "Test Task Updated",
			description: "Describtion updated",
			date: Date(),
			completed: true,
			id: 1
		)
		taskManager.addTask(task: task)

		// Act
		taskManager.editTask(task: updatedTask)

		// Assert

		XCTAssertTrue(mockStorageManager.editTaskCalled, "Метод editTask должен быть вызван")
		XCTAssertEqual(mockStorageManager.editedTask?.title, updatedTask.title, "Обновлённая задача должна иметь новое название")
		XCTAssertEqual(taskManager.taskList.first?.title, updatedTask.title, "Список задач должен содержать обновлённую задачу")
	}


}

final class MockStorageManager: IStorageManager {
	
	
	var saveTaskCalled = false
	var savedTask: (id: Int, title: String, description: String, isCompleted: Bool, date: Date)?
	
	var editTaskCalled = false
	var editedTask: (id: Int, title: String, description: String, date: Date, completed: Bool)?
	
	var deleteTaskWithIdCalled = false
	var deletedTaskId: Int?
	
	func saveTask(id: Int, title: String, description: String, isCompleted: Bool, date: Date) {
		saveTaskCalled = true
		savedTask = (id, title, description, isCompleted, date)
	}
	
	func fetchTasks() -> [TaskEntity] {
		return []
	}

	func editTask(id: Int, title: String, description: String, date: Date, completed: Bool) {
		editTaskCalled = true
		editedTask = (id, title, description, date, completed)
	}
	
	func deleteTask(_ task: TaskEntity) {
	}
	
	func deleteTask(withId id: Int) {
		deleteTaskWithIdCalled = true
		deletedTaskId = id
	}
	func saveTasks(taskItems: [TodoListApp.TaskItem]) {
		
	}
}

