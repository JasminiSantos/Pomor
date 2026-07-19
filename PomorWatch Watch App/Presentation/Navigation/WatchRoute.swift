import PomorCore

enum WatchRoute: Hashable {
    case home
    case timer(PomTask)
    case addTask
}
