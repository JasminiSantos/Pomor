import PomorCore

enum TaskFormMode: Hashable {
    case create
    case edit(PomTask)

    var navigationTitle: String {
        switch self {
        case .create: return "New Session"
        case .edit:   return "Edit Session"
        }
    }

    var buttonTitle: String {
        switch self {
        case .create: return "Create Session"
        case .edit:   return "Save Changes"
        }
    }
}
