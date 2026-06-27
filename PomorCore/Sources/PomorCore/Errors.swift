import Foundation

public enum TaskError: LocalizedError, Sendable {
    case emptyTitle
    case invalidDuration(Int)
    case notFound
    case invalidInput(String)

    public var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Title cannot be empty."
        case .invalidDuration(let value):
            return "Duration (\(value)) must be greater than 0."
        case .notFound:
            return "Task not found."
        case .invalidInput(let message):
            return message
        }
    }
}

public enum DataSourceError: Error, Sendable {
    case encodingFailed
    case decodingFailed
    case persistenceFailed
}
