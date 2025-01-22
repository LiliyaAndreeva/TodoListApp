//
//  TaskDetailViewController.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 20.01.2025.
//


import UIKit
protocol ITaskDetailsViewController: AnyObject {
	func updateTaskData(_ task: TaskItem?)
	func updateUI(with task: TaskItem)
}

final class TaskDetailsViewController: UIViewController {
	var task: TaskItem?
	var isEditingMode: Bool = false
	var presenter: ITaskDetailsPresenter!
	
	private lazy var titleTextView = setupTitleTextView()
	
	private lazy var descriptionTextView = setupDescriptionTextView()
	private lazy var dateLabel = setupDateLabel()
	private lazy var stackView = setupVerticalStackView()
	
	override func viewDidLoad() {
		setupUI()
		presenter.onViewDidLoad()
	}

	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setToolbarHidden(true, animated: animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setToolbarHidden(false, animated: animated)
	}
	
}

extension TaskDetailsViewController: ITaskDetailsViewController {

	func updateUI(with task: TaskItem) {

		titleTextView.text = task.title
		descriptionTextView.text = task.description
	}
	func updateTaskData(_ task: TaskItem?) {
		self.task = task
		titleTextView.text = task?.title ?? "Заголовок"
		descriptionTextView.text = task?.description ?? ""
		dateLabel.text = DateFormatter.localizedString(
			from: task?.date ?? Date(),
			dateStyle: .medium,
			timeStyle: .none
		)
	}
}
	


// MARK: - SetupUI
extension TaskDetailsViewController {

	func setupTitleTextView() -> UITextView {
		let textView = UITextView()
		textView.font = UIFont.sfProBold(size: FontSizes.sizeBig)
		textView.textColor = .white
		textView.backgroundColor = .clear
		textView.isScrollEnabled = false
		textView.isEditable = true
		textView.delegate = self
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0
		return textView
	}
	
	func setupDateLabel() -> UILabel {
		let label = UILabel()
		label.font = UIFont.sfProRegular(size: FontSizes.sizeS)
		label.textColor = .gray
		label.textAlignment = .right
		label.text = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none)
		
		return label
	}
	

	func setupDescriptionTextView() -> UITextView {
		let textView = UITextView()
		textView.font = UIFont.sfProRegular(size: FontSizes.sizeM)
		textView.textColor = .white
		textView.backgroundColor = .clear
		//textView.backgroundColor = .red
		textView.isEditable = true
		textView.isScrollEnabled = true
		textView.delegate = self
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.lineSpacing = 8
		
		return textView
	}

	
	func setupVerticalStackView() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [titleTextView, dateLabel])
		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .equalSpacing
		stack.spacing = 12
		return stack
	}
	
	func setupUI() {
		view.addSubview(descriptionTextView)
		view.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 106),
			
			descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			descriptionTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
			descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
			titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
		])
	}

}

extension TaskDetailsViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == .lightGray {
			textView.text = nil
			textView.textColor = .white
		}
		textView.becomeFirstResponder()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {

		guard let task = task else { return }
		
		if textView == titleTextView {
			task.title = textView.text
		} else if textView == descriptionTextView {
			task.description = textView.text
		}
		presenter.updateTask(task)
	}
}
