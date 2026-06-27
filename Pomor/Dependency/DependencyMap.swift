import PomorDI
import PomorCore

struct DependencyMap {

    static func register(in container: DIContainer) {

        container.registerSingleton(TaskDataSource.self) { _ in
            LocalTaskDataSource()
        }

        container.registerSingleton(TaskRepository.self) { r in
            TaskRepositoryImpl(dataSource: r.resolve(TaskDataSource.self))
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
                deleteTaskUseCase: r.resolve(DeleteTaskUseCase.self)
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

        container.register(TimerViewModel.self) { r, task in
            TimerViewModel(
                task: task,
                engine: DefaultPomodoroEngine(
                    config: r.resolve(PomodoroConfiguration.self)
                )
            )
        }
    }
}
