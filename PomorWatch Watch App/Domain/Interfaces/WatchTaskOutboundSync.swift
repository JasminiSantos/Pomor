import PomorCore

protocol WatchTaskOutboundSync: AnyObject {
    func sendMutation(_ mutation: TaskSyncMutation)
}
