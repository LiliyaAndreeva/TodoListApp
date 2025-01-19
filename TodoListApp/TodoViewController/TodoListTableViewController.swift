//
//  ViewController.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

protocol ITodoListViewController: AnyObject {
	func displayTasks(tasks: [TaskItem])
}

final class TodoListViewController: UITableViewController {

	private var tasks: [TaskItem] = []
	var presenter: ITodoListPresenterProtocol!

	required init() {
		super.init(style: .plain)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		presenter.viewDidLoad()
	}

}

// MARK: - TableViewDelegate
extension TodoListViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
		
		let task = tasks[indexPath.row]
		cell.task = task
		
		return cell
	}
}

// MARK: - TableViewDataSource
extension TodoListViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = tasks[indexPath.row]
		presenter.didSelectTask(task)

//		tableView.reloadRows(at: [indexPath], with: .automatic)
	}
}
extension TodoListViewController : ITodoListViewController {
	func displayTasks(tasks: [TaskItem]) {
		self.tasks = tasks
		tableView.reloadData() // Обновляем таблицу
	}
}


