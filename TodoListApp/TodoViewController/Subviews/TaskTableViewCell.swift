//
//  TaskTableViewCell.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit
final class TaskTableViewCell: UITableViewCell {
	
	static let identifier = "TaskTableViewCell"
	var onToggleCompletion: ((Int) -> Void)?
	var taskId: Int?
	
	// UI элементы
	private lazy var statusButton = setupButon()
	private lazy var titleLabel = setupTitleLabel()
	private lazy var descriptionLabel = setupDescribtionLabel()
	private lazy var dateLabel = setupDateLabel()
	private lazy var stackView = setupVerticalStackView()
	private lazy var horizontalStackView = setupHorizontalStackView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		contentView.backgroundColor = .systemBackground
		backgroundColor = .clear
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(
		title: String,
		description: String,
		date: Date,
		isCompleted: Bool,
		with task: TaskItem
	) {
		
		titleLabel.text = title
		descriptionLabel.text = description
		dateLabel.text = formatDate(date: date)
		statusButton.isChecked = isCompleted

		taskId = task.id
		updateTitleLabelAppearance(isCompleted: isCompleted)
	}
}

private extension TaskTableViewCell {

	func formatDate(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd/MM/yy"
		return dateFormatter.string(from: date)
	}

	@objc func didToggleSwitch() {
		print("did tapped")
		
		guard let taskId = taskId else {
			print("Ошибка: taskId равен nil")
			return
		}
		
		onToggleCompletion?(taskId)
		updateTitleLabelAppearance(isCompleted: statusButton.isChecked)
	}

	func updateTitleLabelAppearance(isCompleted: Bool) {
		let textColor: UIColor = isCompleted ? .gray : .label
		let textAttributes: [NSAttributedString.Key: Any] = isCompleted
		? [.foregroundColor: textColor, .strikethroughStyle: NSUnderlineStyle.single.rawValue]
		: [.foregroundColor: textColor, .strikethroughStyle: 0]
		
		titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "", attributes: textAttributes)
	}
}

// MARK: Setup UI
private extension TaskTableViewCell {


	func setupButon() -> CustomButton {
		let button = CustomButton()
		button.addTarget(self, action: #selector(didToggleSwitch), for: .touchUpInside)
		return button
	}

	 func setupTitleLabel() -> UILabel {
		let label = UILabel()
		label.font = UIFont.sfPro(size: FontSizes.sizeM )
		label.textColor = .white
		label.numberOfLines = 1
		return label
	}

	func setupDescribtionLabel() -> UILabel {
		let label = UILabel()

		label.font = UIFont.sfPro(size: FontSizes.sizeS)
		label.textColor = .gray
		label.numberOfLines = 2
		return label
	}

	func setupDateLabel() -> UILabel {
		let label = UILabel()
		label.font = UIFont.sfPro(size: FontSizes.sizeS)
		label.textColor = .gray
		label.textAlignment = .right
		return label
	}

	func setupVerticalStackView() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
		stack.axis = .vertical
		stack.alignment = .leading
		stack.distribution = .fillEqually
		stack.spacing = SpacingSizes.sizeXS
		return stack
	}

	func setupHorizontalStackView() -> UIStackView {
		let stack = UIStackView(arrangedSubviews: [statusButton, stackView])
		stack.axis = .horizontal
		stack.alignment = .top
		stack.spacing = SpacingSizes.sizeM
		return stack
	}

	func setupUI(){

		contentView.addSubview(horizontalStackView)
		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: ConstraintSizes.sizeL),
			horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -ConstraintSizes.sizeL),
			horizontalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			horizontalStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: ConstraintSizes.sizeS),
			horizontalStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -ConstraintSizes.sizeS),
			
			statusButton.widthAnchor.constraint(equalToConstant: ConstraintSizes.sizeXl),
			statusButton.heightAnchor.constraint(equalToConstant: ConstraintSizes.sizeXl)
		])
	}
}
