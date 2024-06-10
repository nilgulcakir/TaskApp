//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Nilgul Cakir on 2.06.2024.
//

import Foundation
import Alamofire

class TaskViewModel {
    private var tasks: [Task] = []
    private var filteredTasks: [Task] = []
    private var accessToken: String?

    var onTasksUpdated: (() -> Void)?

    var numberOfTasks: Int {
        return filteredTasks.count
    }

    func task(at index: Int) -> Task {
        return filteredTasks[index]
    }

    func fetchTasks() {

        let loginHeaders: HTTPHeaders = [
            "Authorization": "Basic QVBJX0V4cGxvcmVyOjEyMzQ1NmlzQUxhbWVQYXNz",
            "Content-Type": "application/json"
        ]

        let loginParameters: [String: Any] = [
            "username": "365",
            "password": "1"
        ]

        AF.request("https://api.baubuddy.de/index.php/login", method: .post, parameters: loginParameters, encoding: JSONEncoding.default, headers: loginHeaders).responseJSON { response in
            switch response.result {
            case .success(let data):
                if let json = data as? [String: Any], let oauth = json["oauth"] as? [String: Any], let accessToken = oauth["access_token"] as? String {
                    self.accessToken = accessToken
                    self.fetchTasksWithToken(accessToken)
                } else {
                    print("Failed to parse login response")
                }
            case .failure(let error):
                print("Login failed with error: \(error)")
            }
        }
    }

    private func fetchTasksWithToken(_ token: String) {
    
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        AF.request("https://api.baubuddy.de/dev/index.php/v1/tasks/select", headers: headers).responseDecodable(of: [Task].self) { response in
            switch response.result {
            case .success(let tasks):
                self.tasks = tasks
                self.filteredTasks = tasks
                self.onTasksUpdated?()
            case .failure(let error):
                print("Fetch tasks failed with error: \(error)")
            }
        }
    }

    func searchTasks(with query: String) {
        if query.isEmpty {
            filteredTasks = tasks
        } else {
            filteredTasks = tasks.filter { task in
                task.task.contains(query) || task.title.contains(query) || task.description.contains(query) || task.colorCode.contains(query)
            }
        }
        onTasksUpdated?()
    }
    
}
