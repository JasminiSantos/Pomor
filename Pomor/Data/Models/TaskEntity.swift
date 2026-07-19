import Foundation
import PomorCore
import SwiftData

@Model
final class TaskEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var duration: Int
    var icon: String

    init(id: UUID, title: String, duration: Int, icon: String) {
        self.id = id
        self.title = title
        self.duration = duration
        self.icon = icon
    }

    convenience init(from task: PomTask) {
        self.init(
            id: task.id,
            title: task.title,
            duration: task.duration,
            icon: task.icon
        )
    }

    func apply(_ task: PomTask) {
        title = task.title
        duration = task.duration
        icon = task.icon
    }

    func toDomain() -> PomTask {
        PomTask(id: id, title: title, duration: duration, icon: icon)
    }
}
