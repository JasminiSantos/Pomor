import PomorCore
import PomorDI

struct WatchDependencyMap {
    let container: DIContainer

    static func live() -> WatchDependencyMap {
        let container = DIContainer()
        register(in: container)
        _ = container.resolve(WatchTaskInboundSync.self)
        return WatchDependencyMap(container: container)
    }

    private static func register(in container: DIContainer) {
        container.registerSingleton(WatchTaskOutboundSync.self) { _ in
            WatchConnectivityManager.shared
        }

        container.registerSingleton(WatchTaskInboundSync.self) { _ in
            WatchConnectivityManager.shared
        }

        container.registerSingleton(WatchTaskDataSource.self) { _ in
            WatchLocalTaskDataSource()
        }

        container.registerSingleton(WatchTaskRepository.self) { r in
            WatchTaskRepositoryImpl(
                dataSource: r.resolve(WatchTaskDataSource.self),
                outboundSync: r.resolve(WatchTaskOutboundSync.self)
            )
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

        container.registerSingleton(TimerService.self) { _ in
            DefaultTimerService()
        }

        container.register(PomodoroEngine.self) { r in
            DefaultPomodoroEngine(config: r.resolve(PomodoroConfiguration.self))
        }

        container.register(WatchTimerViewModel.self) { r, task in
            WatchTimerViewModel(
                task: task,
                timerService: r.resolve(TimerService.self),
                engine: r.resolve(PomodoroEngine.self)
            )
        }

        container.registerSingleton(WatchTaskListViewModel.self) { r in
            WatchTaskListViewModel(
                getTasksUseCase: r.resolve(GetWatchTasksUseCase.self),
                addTaskUseCase: r.resolve(AddWatchTaskUseCase.self),
                deleteTaskUseCase: r.resolve(DeleteWatchTaskUseCase.self),
                syncTasksUseCase: r.resolve(SyncWatchTasksUseCase.self),
                inboundSync: r.resolve(WatchTaskInboundSync.self)
            )
        }
    }
}
