//
//  ViewController.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit

protocol ITodoListViewController: AnyObject {
	func displayTasks(tasks: [TaskItem])
	func updateTask(_ task: TaskItem)
}

final class TodoListViewController: UIViewController{
	
	private lazy var searchBar: UISearchBar = setupSearchBar()
	private lazy var tableView: UITableView = setupTableView()

	var tasks: [TaskItem] = []
	var presenter: ITodoListPresenterProtocol!
	
	private var filteredTasks: [TaskItem] = []
	private var isSearchActive: Bool = false


	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		setupUI()
		setupnavigationUI()
		presenter.viewDidLoad()
		
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
		DispatchQueue.main.async {
			self.searchBar.resignFirstResponder()
		}
	}
}

// MARK: - TableViewDelegate
extension TodoListViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isSearchActive ? filteredTasks.count : tasks.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: TaskTableViewCell.identifier,
			for: indexPath
		) as! TaskTableViewCell
		let task = isSearchActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]

		cell.configure(
			title: task.title,
			description: task.description ?? "",
			date: task.date ?? Date(),
			isCompleted: task.isCompleted,
			with: task
		)

		cell.onToggleCompletion = { [weak self] taskId in
			self?.presenter.toggleTaskCompletion(taskId: taskId)
		}
		let interaction = UIContextMenuInteraction(delegate: self)
		cell.addInteraction(interaction)
		
		return cell
	}
}

// MARK: - TableViewDataSource
extension TodoListViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = isSearchActive ? filteredTasks[indexPath.row] : tasks[indexPath.row]
		presenter.didSelectTask(task)
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return calculateCellHeight(for: 6)
	}

}

// MARK: - Protocol's Functions
extension TodoListViewController : ITodoListViewController {

	func displayTasks(tasks: [TaskItem]) {
		self.tasks = tasks
		updateTaskCountLabel()
		tableView.reloadData()
	}

	func updateTask(_ task: TaskItem) {
		if let index = tasks.firstIndex(where: { $0.id == task.id }) {
			tasks[index] = task
			tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
		}
	}
}

// MARK: - SetupUI
private extension TodoListViewController {
	func configureNavigationBar() {
		title = "Заметки"
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	func setupToolbarItems() {
		
		let taskCountBarButtonItem = createTaskCountBarButtonItem()
		let editButtonItem = createEditButtonItem()
		
		let flexibleSpace1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		
		toolbarItems = [flexibleSpace1, taskCountBarButtonItem, flexibleSpace2, editButtonItem]
		configureToolbarAppearance()
		navigationController?.setToolbarHidden(false, animated: false)
	}
	
	func configureToolbarAppearance() {
		let appearance = UIToolbarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = .systemGray5
		navigationController?.toolbar.standardAppearance = appearance
		navigationController?.toolbar.scrollEdgeAppearance = appearance
	}
	
	func createTaskCountBarButtonItem() -> UIBarButtonItem {
		
		let taskCountLabel = UILabel()
		taskCountLabel.text = "\(tasks.count) задач"
		taskCountLabel.textColor = .white
		taskCountLabel.font = UIFont.systemFont(ofSize: FontSizes.sizeM)
		taskCountLabel.sizeToFit()
		
		let taskCountView = UIView()
		taskCountView.addSubview(taskCountLabel)
		
		taskCountLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			taskCountLabel.centerXAnchor.constraint(equalTo: taskCountView.centerXAnchor),
			taskCountLabel.centerYAnchor.constraint(equalTo: taskCountView.centerYAnchor)
		])
		
		let taskCountBarButtonItem = UIBarButtonItem(customView: taskCountView)
		taskCountBarButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
		
		return taskCountBarButtonItem
	}
	
	func createEditButtonItem() -> UIBarButtonItem {
		
		if let editImage = UIImage(systemName: "square.and.pencil") {
			let editButtonItem = UIBarButtonItem(
				image: editImage,
				style: .plain,
				target: self,
				action: #selector(editButtonTapped)
			)
			editButtonItem.tintColor = .accent
			editButtonItem.setTitleTextAttributes([.foregroundColor: UIColor.accent], for: .normal)
			return editButtonItem
		}
		return UIBarButtonItem()
	}
	
	func setupSearchBar() -> UISearchBar {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Search"
		searchBar.backgroundImage = UIImage()
		searchBar.backgroundColor = .systemGray5
		searchBar.layer.cornerRadius = CornerRadiusSize.normal
		searchBar.clipsToBounds = true
		searchBar.delegate = self
		return searchBar
	}
	
	func setupTableView() -> UITableView {
		let tableView = UITableView(frame: .zero, style: .plain)
		tableView.backgroundColor = .systemBackground
		tableView.separatorColor = .darkGray
		tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}
	func setupBackButton() {
		let backButton = UIBarButtonItem()
		backButton.title = "Назад" // Устанавливаем текст кнопки
		navigationItem.backBarButtonItem = backButton
	}
	func setupnavigationUI() {
		configureNavigationBar()
		setupToolbarItems()
		setupBackButton()
	}
	
	func setupUI() {
		view.addSubview(searchBar)
		view.addSubview(tableView)
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ConstraintSizes.sizeS),
			searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintSizes.sizeL),
			searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintSizes.sizeL),
			searchBar.heightAnchor.constraint(equalToConstant: ConstraintSizes.sizeBig),
			
			tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: ConstraintSizes.sizeS),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}
	
	func calculateCellHeight(for visibleRows: CGFloat) -> CGFloat {
		let totalScreenHeight = UIScreen.main.bounds.height
		let safeAreaInsets = view.safeAreaInsets
		let availableHeight = totalScreenHeight - safeAreaInsets.top - safeAreaInsets.bottom
		return availableHeight / visibleRows
	}
	
}
	
// MARK: - Supported functions
private extension TodoListViewController {
	func updateTaskCountLabel() {
		if let taskCountItem = toolbarItems?.first(where: { $0.customView is UIView }),
		   let taskCountView = taskCountItem.customView as? UIView,
		   let taskCountLabel = taskCountView.subviews.first as? UILabel {
			taskCountLabel.text = "\(tasks.count) задач"
		} else {
			print("UILabel for task count not found")
		}
	}
	@objc
	func editButtonTapped() {
		presenter.addNewTask()
		print("кнопка создания новой задачи нажата")
	}
}

// MARK: - UISearchBarDelegate
extension TodoListViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			isSearchActive = !searchText.isEmpty
			filteredTasks = tasks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
			tableView.reloadData()
		}
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = true
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		isSearchActive = false
		searchBar.text = ""
		searchBar.resignFirstResponder()
		tableView.reloadData()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchBar.showsCancelButton = false
		searchBar.resignFirstResponder()
	}

}
// MARK: - UIContextMenuInteractionDelegate
extension TodoListViewController: UIContextMenuInteractionDelegate {
	func contextMenuInteraction(
		_ interaction: UIContextMenuInteraction,
		configurationForMenuAtLocation location: CGPoint
	) -> UIContextMenuConfiguration? {
		guard let cell = interaction.view as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
		
		let task = tasks[indexPath.row]
		return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
			guard let self = self else { return nil }
			return self.createContextMenu(for: task, at: indexPath)
		}
	}

	
	func createContextMenu(for task: TaskItem, at indexPath: IndexPath) -> UIMenu {
		let editAction = UIAction(
			title: "Редактировать",
			image: UIImage(systemName: "pencil")
		) { [weak self] _ in
			self?.presenter.didSelectTask(task)
		}

		let shareAction = UIAction(
			title: "Поделиться",
			image: UIImage(systemName: "square.and.arrow.up")
		) { [weak self] _ in
			self?.presenter.shareTask(at: indexPath)
		}
		
		let deleteAction = UIAction(
			title: "Удалить",
			image: UIImage(systemName: "trash"),
			attributes: .destructive
		) { [weak self] _ in
			self?.presenter.deleteTask(at: indexPath)
		}
		return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
	}
}
