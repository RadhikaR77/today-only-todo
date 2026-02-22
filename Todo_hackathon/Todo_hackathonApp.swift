import SwiftUI
import CoreData

@main
struct Todo_hackathonApp: App {
    
    let persistence = PersistenceController.shared
    private let repository: TaskRepository
    
    init() {
        let context = persistence.container.viewContext
        self.repository = TaskRepositoryImpl(context: context)
        repository.cleanupOldTasks(keepingLast: 30)
    }
    
    var body: some Scene {
        WindowGroup {
            TodayView(
                viewModel: TodayViewModel(repo: repository)
            )
        }
    }
}
