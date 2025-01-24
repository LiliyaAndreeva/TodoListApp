//
//  CustomButton.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 20.01.2025.
//

import UIKit
class CustomButton: UIButton {
	// MARK: - Properties
	private let checkmarkImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(systemName: "checkmark")
		imageView.tintColor = .gray
		imageView.alpha = 0
		return imageView
	}()
	
	private let circleView: UIView = {
		let view = UIView()
		view.layer.cornerRadius = 12
		view.layer.borderWidth = 2
		view.layer.borderColor = UIColor.gray.cgColor
		return view
	}()
	
	var isChecked: Bool = false {
		didSet {
			updateAppearance()
		}
	}
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	// MARK: - Setup UI
	private func setupUI() {
		addSubview(circleView)
		addSubview(checkmarkImageView)
		
		self.isUserInteractionEnabled = true
		circleView.isUserInteractionEnabled = false
		checkmarkImageView.isUserInteractionEnabled = false
		
		// Auto Layout
		circleView.translatesAutoresizingMaskIntoConstraints = false
		checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			circleView.widthAnchor.constraint(equalToConstant: 24),
			circleView.heightAnchor.constraint(equalToConstant: 24),
			circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			circleView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

			checkmarkImageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
			checkmarkImageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
			checkmarkImageView.widthAnchor.constraint(equalToConstant: 14),
			checkmarkImageView.heightAnchor.constraint(equalToConstant: 14)
		])

		addTarget(self, action: #selector(toggleCheck), for: .touchUpInside)
	}
	
	// MARK: - Update Appearance
	private func updateAppearance() {
		let tintColor = isChecked ? .accent : UIColor.gray
		circleView.layer.borderColor = tintColor.cgColor
		checkmarkImageView.tintColor = tintColor
		checkmarkImageView.alpha = isChecked ? 1 : 0 
	}
	
	// MARK: - Actions
	@objc private func toggleCheck() {
		isChecked.toggle()
	}
}
