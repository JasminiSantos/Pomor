import Foundation

struct Task: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var title: String
    var duration: Int
    var icon: String
}
