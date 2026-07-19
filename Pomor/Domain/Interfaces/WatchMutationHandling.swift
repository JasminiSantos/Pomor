import PomorCore

/// Aplica mutações vindas do Watch na fonte da verdade (iPhone).
protocol WatchMutationHandling: AnyObject {
    func handleWatchMutation(_ mutation: TaskSyncMutation)
}
