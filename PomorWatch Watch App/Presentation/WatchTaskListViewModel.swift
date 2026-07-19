import Foundation
import Combine
import PomorCore

@MainActor
final class WatchTaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [PomTask] = []
    @Published private(set) var hasSyncedFromPhone = false

    private let getTasksUseCase: GetWatchTasksUseCase
    private let addTaskUseCase: AddWatchTaskUseCase
    private let deleteTaskUseCase: DeleteWatchTaskUseCase
    private let syncTasksUseCase: SyncWatchTasksUseCase
    private let inboundSync: WatchTaskInboundSync
    private var cancellable: AnyCancellable?

    init(
        getTasksUseCase: GetWatchTasksUseCase,
        addTaskUseCase: AddWatchTaskUseCase,
        deleteTaskUseCase: DeleteWatchTaskUseCase,
        syncTasksUseCase: SyncWatchTasksUseCase,
        inboundSync: WatchTaskInboundSync
    ) {
        self.getTasksUseCase = getTasksUseCase
        self.addTaskUseCase = addTaskUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.syncTasksUseCase = syncTasksUseCase
        self.inboundSync = inboundSync
        reload()
        observeInboundSync()
    }

    func add(title: String, duration: Int) {
        guard case .success = addTaskUseCase.execute(title: title, duration: duration) else { return }
        reload()
    }

    func delete(_ task: PomTask) {
        guard case .success = deleteTaskUseCase.execute(task) else { return }
        reload()
    }

    private func reload() {
        if case .success(let loaded) = getTasksUseCase.execute() {
            tasks = loaded
        }
        hasSyncedFromPhone = getTasksUseCase.hasSyncedFromPhone
    }

    private func observeInboundSync() {
        cancellable = inboundSync.tasksReceived
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tasks in
                self?.applyInboundTasks(tasks)
            }

        inboundSync.replayCachedTasksIfAvailable()
    }

    private func applyInboundTasks(_ inboundTasks: [PomTask]) {
        guard case .success = syncTasksUseCase.execute(inboundTasks) else { return }
        tasks = inboundTasks
        hasSyncedFromPhone = true
    }
}
