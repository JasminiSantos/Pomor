import PomorCore

struct WatchDependencyMap {
    static func register(in container: WatchDIContainer) {
        container.registerSingleton(WatchTaskDataSource.self) { _ in
            WatchLocalTaskDataSource()
        }

        container.registerSingleton(WatchTaskRepository.self) { r in
            WatchTaskRepositoryImpl(dataSource: r.resolve(WatchTaskDataSource.self))
        }

        container.register(GetWatchTasksUseCase.self) { r in
            GetWatchTasksUseCase(repository: r.resolve(WatchTaskRepository.self))
        }

        container.register(AddWatchTaskUseCase.self) { r in
            AddWatchTaskUseCase(repository: r.resolve(WatchTaskRepository.self))
        }

        container.register(DeleteWatchTaskUseCase.self) { r in
            DeleteWatchTaskUseCase(repository: r.resolve(WatchTaskRepository.self))
        }

        container.register(SyncWatchTasksUseCase.self) { r in
            SyncWatchTasksUseCase(repository: r.resolve(WatchTaskRepository.self))
        }

        container.registerSingleton(PomodoroConfiguration.self) { _ in
            PomodoroConfiguration()
        }

        container.registerSingleton(WatchTaskListViewModel.self) { r in
            WatchTaskListViewModel(
                getTasksUseCase: r.resolve(GetWatchTasksUseCase.self),
                addTaskUseCase: r.resolve(AddWatchTaskUseCase.self),
                deleteTaskUseCase: r.resolve(DeleteWatchTaskUseCase.self),
                syncTasksUseCase: r.resolve(SyncWatchTasksUseCase.self)
            )
        }
    }
}
