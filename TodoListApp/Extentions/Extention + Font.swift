//
//  Extention + Font.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 21.01.2025.
//

import UIKit
extension UIFont {
	static func customFont(name: String, size: CGFloat) -> UIFont {
		return UIFont(name: name, size: size) ?? UIFont()
		
	}
	static func sfPro(size: CGFloat) -> UIFont {
		return customFont(name: "SFPro-Regular", size: size)
	}
}
