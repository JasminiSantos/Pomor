import Foundation

public struct PomTask: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let id: UUID
    public var title: String
    public var duration: Int
    public var icon: String

    public init(id: UUID, title: String, duration: Int, icon: String) {
        self.id = id
        self.title = title
        self.duration = duration
        self.icon = icon
    }
}
