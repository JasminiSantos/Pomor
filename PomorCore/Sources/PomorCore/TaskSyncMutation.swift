import Foundation

public enum WatchConnectivityPayload {
    public static let tasks = "tasks"
    public static let mutation = "mutation"
}

public enum TaskSyncMutation: Codable, Equatable, Sendable {
    case add(PomTask)
    case delete(UUID)
}
