//
//  NetworkManager.swift
//  TodoListApp
//
//  Created by Лилия Андреева on 19.01.2025.
//

import Foundation

enum TaskListsErrors: Error {
	case invalidURL
	case noData
	case decodingError
	case networkError(Error)
	
	var localizedDescription: String {
		switch self {
		case .invalidURL:
			return "Invalid URL."
		case .noData:
			return "No data received."
		case .decodingError:
			return "Failed to decode data."
		case .networkError(let error):
			return "Network error: \(error.localizedDescription)"
		}
	}
}

enum NetworkMethods {
	static let get = "GET"
}

enum URLs: String {
	case startUrl = "https://dummyjson.com/todos"
}

protocol INetworkmanager {
	func fetchData<T: Codable>(url: URLs, method: String, completion: @escaping (T?, TaskListsErrors?) -> Void)
}

final class NetworkManager: INetworkmanager {
	
	static let shared = NetworkManager()
	private init() {}
	
	func fetchData<T: Codable >(
		url: URLs,
		method: String = NetworkMethods.get,
		completion: @escaping (T?, TaskListsErrors?) -> Void
	)  {
		guard let url = URL(string: url.rawValue) else {
			completion(nil, .invalidURL)
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method
		
		let session = URLSession.shared
		
		let task = session.dataTask(with: request) { data, response, error in
			if let error = error {
				DispatchQueue.main.async {
					completion(nil, .networkError(error))
				}
				return
			}
			
			
			guard let data = data else {
				DispatchQueue.main.async {
					completion(nil, .noData)
				}
				return
			}
			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				DispatchQueue.main.async {
					completion(decodedData, nil)
				}
			} catch {
				DispatchQueue.main.async {
					completion(nil, .decodingError)
				}
			}
		}
		task.resume()
	}
	func fetchData1<T: Codable>(
		url: URLs,
		method: String = NetworkMethods.get,
		completion: @escaping (T?, TaskListsErrors?) -> Void
	) {
		guard let url = URL(string: url.rawValue) else {
			completion(nil, .invalidURL)
			return
		}

		var request = URLRequest(url: url)
		request.httpMethod = method

		let session = URLSession.shared
		let task = session.dataTask(with: request) { data, response, error in
			if let error = error {
				DispatchQueue.main.async {
					completion(nil, .networkError(error))
				}
				return
			}

			guard let data = data else {
				DispatchQueue.main.async {
					completion(nil, .noData)
				}
				return
			}

			do {
				let decodedData = try JSONDecoder().decode(T.self, from: data)
				DispatchQueue.main.async {
					completion(decodedData, nil)
				}
			} catch {
				DispatchQueue.main.async {
					completion(nil, .decodingError)
				}
			}
		}
		task.resume()
	}
	
}
