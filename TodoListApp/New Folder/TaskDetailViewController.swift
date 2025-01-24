//
//  TaskDetailViewController.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 20.01.2025.
//


import UIKit
protocol ITaskDetailsViewController: AnyObject {
	func updateTaskData(_ task: TaskItem?)
}

final class TaskDetailsViewController: UIViewController {
	var task: TaskItem?
	var presenter: ITaskDetailsPresenter!
	var onSave: ((TaskItem?) -> Void)?
	
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
		
		if let updatedTask = saveTaskIfNeeded(), isMovingFromParent {
			onSave?(updatedTask)
		}
	}

}

extension TaskDetailsViewController: ITaskDetailsViewController {

	func updateTaskData(_ task: TaskItem?) {
		self.task = task
		titleTextView.text = task?.title ?? "Введите название задачи"
		descriptionTextView.text = task?.description ?? ""
		dateLabel.text = DateFormatter.localizedString(
			from: task?.date ?? Date(),
			dateStyle: .medium,
			timeStyle: .none
		)
	}
	
	@discardableResult
	private func saveTaskIfNeeded() -> TaskItem? {
		guard let updatedTask = task else { return nil }

		let hasTitleChanged = titleTextView.text != updatedTask.title
		let hasDescriptionChanged = descriptionTextView.text != updatedTask.description

		if hasTitleChanged {
			updatedTask.title = titleTextView.text
		}

		if hasDescriptionChanged {
			updatedTask.description = descriptionTextView.text
		}

		if hasTitleChanged || hasDescriptionChanged {
			presenter.updateTask(updatedTask)
			print("Task was updated and saved: \(updatedTask.title)")
		}
		return updatedTask
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
		textView.textContainer.lineBreakMode = .byWordWrapping
		textView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintSizes.sizeXl),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintSizes.sizeXl),
			stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 106),
			
			descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ConstraintSizes.sizeXl),
			descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ConstraintSizes.sizeXl),
			descriptionTextView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: ConstraintSizes.sizeL),
			descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -ConstraintSizes.sizeXl),
			titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
		])
	}

}

extension TaskDetailsViewController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.becomeFirstResponder()
		if textView == titleTextView {
			if textView.text == "Введите название задачи" {
				textView.text = ""
				textView.textColor = .white
			}
		} else {
			if textView.text == "Введите описание задачи" {
				textView.text = ""
				textView.textColor = .white
			}
		}
	}
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView == descriptionTextView && textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			textView.text = "Введите описание задачи"
			textView.textColor = .gray
		}
	}
	func textViewDidChange(_ textView: UITextView) {
			let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: .greatestFiniteMagnitude))
			textView.constraints.forEach { constraint in
				if constraint.firstAttribute == .height {
					constraint.constant = size.height
				}
			}
			view.layoutIfNeeded()
		}
}
