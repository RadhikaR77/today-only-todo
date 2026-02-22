//
//  TodayViewModel.swift
//  Todo_hackathon
//
//  Created by Radhika on 21/02/26.
//

import Foundation
import Combine

final class TodayViewModel: ObservableObject {

    private let repo: TaskRepository

    @Published var openTasks: [TaskEntity] = []
    @Published var completedTasks: [TaskEntity] = []

    init(repo: TaskRepository) {
        self.repo = repo
        load()
    }

    // Reload after every mutation because CoreData objects are reference types
    // and SwiftUI does not reliably refresh nested property updates.
    func load() {
        let fetchedTasks = repo.fetchTodayTasks()
        openTasks = fetchedTasks.filter{ !$0.isCompleted }
        completedTasks = fetchedTasks.filter(\.isCompleted)
    }

    func add(taskList: [String]) {
        let currentTastCount = openTasks.count + completedTasks.count - 1
        repo.addTask(taskList: taskList, currentTaskCount: currentTastCount)
        load()
    }

    func toggle(_ task: TaskEntity) {
        repo.toggle(task)
        load()
    }

    func delete(_ task: TaskEntity) {
        repo.delete(task)
        load()
    }
}
