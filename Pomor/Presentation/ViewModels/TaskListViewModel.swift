import PomorCore
import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [PomTask] = []
    @Published var selectedTask: PomTask? = nil
    
    @Published var showMenu = false
    @Published var showDeleteDialog = false
    
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    
    private let getTasksUseCase: GetTasksUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    
    init(
        getTasksUseCase: GetTasksUseCase,
        deleteTaskUseCase: DeleteTaskUseCase
    ) {
        self.getTasksUseCase = getTasksUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        
        loadTasks()
    }
    
    func loadTasks() {
        let result = getTasksUseCase.execute()

        switch result {
        case .success(let fetchedTasks):
            self.tasks = fetchedTasks
        case .failure(let error):
            handle(error)
        }
    }
    
    func deleteTask() {
        guard let task = selectedTask else { return }
        
        let result = deleteTaskUseCase.execute(task: task)
        
        switch result {
        case .success:
            loadTasks()
        case .failure(let error):
            handle(error)
        }
    }
}

private extension TaskListViewModel {
    private func handle(_ error: Error) {
        if let taskError = error as? TaskError {
            errorMessage = taskError.localizedDescription
        } else {
            errorMessage = TaskListStrings.Error.generic
        }
        
        showError = true
    }
}
