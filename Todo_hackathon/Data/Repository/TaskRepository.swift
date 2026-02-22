//
//  TaskRepository.swift
//  Todo_hackathon
//
//  Created by Radhika on 21/02/26.
//

import Foundation
import Combine

protocol TaskRepository {
    func fetchTodayTasks() -> [TaskEntity]
    func addTask(taskList: [String], currentTaskCount: Int)
    func toggle(_ task: TaskEntity)
    func delete(_ task: TaskEntity)
    func cleanupOldTasks(keepingLast days: Int)
}

