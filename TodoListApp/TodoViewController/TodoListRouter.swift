//
//  TodoListRouter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
	func navigateToTaskDetails(for task: TaskItem?)
}

final class TodoListRouter: TodoListRouterProtocol {
	
	weak var viewController: UIViewController?
	
	func navigateToTaskDetails(for task: TaskItem?) {
		if let task = task {
			print("Navigating to Task Details with task: \(task.title)")
		} else {
			print("Navigating to Task Details with a new task")
		}
		
		let defaultTask = TaskItem(title: "Заголовок")
		let taskDetailsViewController = AssemblerTaskDetail.build(with: task ?? defaultTask)
		
		viewController?.navigationController?.pushViewController(taskDetailsViewController, animated: true)
		
	}

}


