import PomorDI
import PomorCore
import SwiftData

struct DependencyMap {

    let container: DIContainer
    let modelContainer: ModelContainer

    static func live() -> DependencyMap {
        let store: SwiftDataPersistentStore
        do {
            store = try SwiftDataPersistentStore()
        } catch {
            fatalError("Failed to create persistent store: \(error)")
        }

        let container = DIContainer()
        register(in: container, taskDataSource: store)

        _ = container.resolve(WatchSyncService.self)
        PhoneConnectivityManager.shared.mutationHandler = container.resolve(WatchMutationHandling.self)

        return DependencyMap(container: container, modelContainer: store.modelContainer)
    }

    private static func register(in container: DIContainer, taskDataSource: TaskDataSource) {

        container.registerSingleton(WatchSyncService.self) { _ in
            PhoneConnectivityManager.shared
        }

        container.registerSingleton(TaskDataSource.self) { _ in
            taskDataSource
        }

        container.registerSingleton(TaskRepository.self) { r in
            TaskRepositoryImpl(
                dataSource: r.resolve(TaskDataSource.self),
                watchSyncService: r.resolve(WatchSyncService.self)
            )
        }

        container.registerSingleton(TasksChangeNotifying.self) { _ in
            TasksChangeNotifier()
        }

        container.registerSingleton(WatchMutationHandling.self) { r in
            PhoneWatchMutationHandler(
                dataSource: r.resolve(TaskDataSource.self),
                repository: r.resolve(TaskRepository.self),
                changeNotifier: r.resolve(TasksChangeNotifying.self)
            )
        }

        container.register(GetTasksUseCase.self) { r in
            GetTasksUseCase(repository: r.resolve(TaskRepository.self))
        }

        container.register(AddTaskUseCase.self) { r in
            AddTaskUseCase(repository: r.resolve(TaskRepository.self))
        }

        container.register(DeleteTaskUseCase.self) { r in
            DeleteTaskUseCase(repository: r.resolve(TaskRepository.self))
        }

        container.register(UpdateTaskUseCase.self) { r in
            UpdateTaskUseCase(repository: r.resolve(TaskRepository.self))
        }

        container.register(TaskListViewModel.self) { r in
            TaskListViewModel(
                getTasksUseCase: r.resolve(GetTasksUseCase.self),
                deleteTaskUseCase: r.resolve(DeleteTaskUseCase.self),
                changeNotifier: r.resolve(TasksChangeNotifying.self)
            )
        }

        container.register(TaskFormViewModel.self) { r, mode in
            TaskFormViewModel(
                mode: mode,
                addTaskUseCase: r.resolve(AddTaskUseCase.self),
                updateTaskUseCase: r.resolve(UpdateTaskUseCase.self)
            )
        }

        container.registerSingleton(PomodoroConfiguration.self) { _ in
            PomodoroConfiguration()
        }

        container.registerSingleton(TimerService.self) { _ in
            DefaultTimerService()
        }

        container.registerSingleton(LiveActivityManaging.self) { _ in
            LiveActivityManager()
        }

        container.register(PomodoroEngine.self) { r in
            DefaultPomodoroEngine(config: r.resolve(PomodoroConfiguration.self))
        }

        container.register(TimerViewModel.self) { r, task in
            TimerViewModel(
                task: task,
                timerService: r.resolve(TimerService.self),
                engine: r.resolve(PomodoroEngine.self),
                liveActivity: r.resolve(LiveActivityManaging.self)
            )
        }
    }
}
