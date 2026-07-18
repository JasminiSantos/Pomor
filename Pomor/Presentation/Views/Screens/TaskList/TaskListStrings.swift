import Foundation

enum TaskListStrings {
    enum Brand {
        static let name = "Pomor"
    }

    enum Greeting {
        static func message(for date: Date = .now) -> String {
            let hour = Calendar.current.component(.hour, from: date)
            switch hour {
            case 5..<12:  return "Good morning! Ready to focus?"
            case 12..<18: return "Good afternoon! Ready to focus?"
            default:      return "Good evening! Ready to focus?"
            }
        }
    }

    enum EmptyState {
        static let title = "No sessions yet"
        static let message = "Tap + to plant your first tomato."
    }

    enum Error {
        static let generic = "Something went wrong."
    }
}
