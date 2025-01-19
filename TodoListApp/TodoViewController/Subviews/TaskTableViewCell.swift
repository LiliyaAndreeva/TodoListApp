//
//  TaskTableViewCell.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import UIKit
final class TaskTableViewCell: UITableViewCell {
	
	static let identifier = "TaskTableViewCell"
	
	// UI элементы
	private let titleLabel = UILabel()
	private let completionSwitch = UISwitch()
	
	var task: TaskItem? {
		didSet {
			configure()
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupViews() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		completionSwitch.translatesAutoresizingMaskIntoConstraints = false
		
		contentView.addSubview(titleLabel)
		contentView.addSubview(completionSwitch)
		
		// Устанавливаем ограничения для titleLabel и completionSwitch
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			
			completionSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			completionSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}
	
	private func configure() {
		guard let task = task else { return }
		
		titleLabel.text = task.title
		completionSwitch.isOn = task.isCompleted
	}
}
