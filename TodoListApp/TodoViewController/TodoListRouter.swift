//
//  TodoListRouter.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

protocol TodoListRouterProtocol: AnyObject {
	func navigateToTaskDetails(for task: TaskItem)
}

final class TodoListRouter: TodoListRouterProtocol {
	
	weak var viewController: UIViewController?
	
	func navigateToTaskDetails(for task: TaskItem) {
		
	}
	
	
}
