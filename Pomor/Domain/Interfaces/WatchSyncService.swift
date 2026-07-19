import PomorCore

protocol WatchSyncService {
    func syncTasks(_ tasks: [PomTask])
}
