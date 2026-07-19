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

    var onOpenTimer: ((PomTask) -> Void)?
    var onAddTask: (() -> Void)?
    var onEditTask: ((PomTask) -> Void)?

    private let getTasksUseCase: GetTasksUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    private let changeNotifier: TasksChangeNotifying
    private var cancellables = Set<AnyCancellable>()

    init(
        getTasksUseCase: GetTasksUseCase,
        deleteTaskUseCase: DeleteTaskUseCase,
        changeNotifier: TasksChangeNotifying
    ) {
        self.getTasksUseCase = getTasksUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.changeNotifier = changeNotifier

        loadTasks()
        observeExternalChanges()
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

    func openTimer(for task: PomTask) {
        onOpenTimer?(task)
    }

    func addTask() {
        onAddTask?()
    }

    func editSelectedTask() {
        showMenu = false
        guard let task = selectedTask else { return }
        onEditTask?(task)
    }

    func requestDeleteSelectedTask() {
        showMenu = false
        showDeleteDialog = true
    }

    func openMenu(for task: PomTask) {
        selectedTask = task
        showMenu = true
    }

    private func observeExternalChanges() {
        changeNotifier.tasksDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.loadTasks()
            }
            .store(in: &cancellables)
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
