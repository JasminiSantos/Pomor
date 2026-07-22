import Foundation

/// Deep links do app (`pomor://app/...`), compartilhados entre app e widgets.
///
/// Formato: `pomor://app/<destination>/[params...]`
/// Exemplos:
/// - `pomor://app/home`
/// - `pomor://app/timer/<taskId>`
public enum PomorDeepLink: Equatable, Sendable {
    case home
    case timer(taskId: UUID)

    public static let scheme = "pomor"
    public static let host = "app"

    public var url: URL {
        var components = URLComponents()
        components.scheme = Self.scheme
        components.host = Self.host
        components.path = "/" + pathComponents.joined(separator: "/")
        return components.url!
    }

    public static func parse(_ url: URL) -> PomorDeepLink? {
        guard url.scheme == scheme, url.host == host else { return nil }

        let parts = url.path
            .split(separator: "/", omittingEmptySubsequences: true)
            .map(String.init)

        guard let destination = parts.first else { return nil }

        switch destination {
        case Destination.home.rawValue where parts.count == 1:
            return .home

        case Destination.timer.rawValue where parts.count == 2:
            guard let taskId = UUID(uuidString: parts[1]) else { return nil }
            return .timer(taskId: taskId)

        default:
            return nil
        }
    }

    public enum Destination: String, Sendable {
        case home
        case timer
    }

    private var pathComponents: [String] {
        switch self {
        case .home:
            return [Destination.home.rawValue]
        case .timer(let taskId):
            return [Destination.timer.rawValue, taskId.uuidString]
        }
    }
}
