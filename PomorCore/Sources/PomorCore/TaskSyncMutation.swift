import Foundation

/// Chaves do payload WatchConnectivity (iPhone ↔ Watch).
public enum WatchConnectivityPayload {
    public static let tasks = "tasks"
    public static let mutation = "mutation"
}

/// Comando de mutação enviado do Watch para o iPhone (fonte da verdade).
public enum TaskSyncMutation: Codable, Equatable, Sendable {
    case add(PomTask)
    case delete(UUID)
}
