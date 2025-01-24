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
		let defaultTask = TaskItem(title: "Введите название задачи")
		guard let taskDetailsViewController = AssemblerTaskDetail.build(with: task ?? defaultTask) as? TaskDetailsViewController else {
			assertionFailure("AssemblerTaskDetail.build не вернул TaskDetailsViewController")
			return
		}
		taskDetailsViewController.onSave = { [weak self] updatedTask in
			guard let self = self else { return }
			if let updatedTask = updatedTask {
				if let presenter = (self.viewController as? TodoListViewController)?.presenter {
					presenter.didEditTask(updatedTask)
				}
			}
		}
		viewController?.navigationController?.pushViewController(taskDetailsViewController, animated: true)
	}
}


