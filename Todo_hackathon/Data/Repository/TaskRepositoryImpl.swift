//
//  TaskRepositoryImpl.swift
//  Todo_hackathon
//
//  Created by Radhika on 21/02/26.
//
import CoreData

final class TaskRepositoryImpl: TaskRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchTodayTasks() -> [TaskEntity] {
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.date(byAdding: .day, value: 1, to: start)!

        request.predicate = NSPredicate(
            format: "createdOn >= %@ AND createdOn < %@",
            start as NSDate,
            end as NSDate
        )

        request.sortDescriptors = [
            NSSortDescriptor(key: "isCompleted", ascending: true),
            NSSortDescriptor(key: "orderIndex", ascending: true)
        ]

        return (try? context.fetch(request)) ?? []
    }

    func addTask(taskList: [String], currentTaskCount: Int) {
        var currOrder = currentTaskCount
        taskList.forEach { name in
            let task = TaskEntity(context: context)
            task.id = UUID()
            task.taskName = name
            task.createdOn = Date()
            task.isCompleted = false
            task.orderIndex = Int64(currOrder)
            currOrder += 1
        }
        save()
    }

    func toggle(_ task: TaskEntity) {
        task.isCompleted.toggle()
        save()
    }

    func delete(_ task: TaskEntity) {
        context.delete(task)
        save()
    }
    
    func cleanupOldTasks(keepingLast days: Int = 30) {
        let request: NSFetchRequest<NSFetchRequestResult> = TaskEntity.fetchRequest()

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let cutoffDate = calendar.date(byAdding: .day, value: -days, to: todayStart)!

        request.predicate = NSPredicate(format: "createdOn < %@", cutoffDate as NSDate)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try context.save()
            print("Old tasks cleaned")
        } catch {
            print("Cleanup failed:", error)
        }
    }

    private func save() {
        try? context.save()
    }
}
