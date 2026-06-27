enum TimerStrings {
    enum State {
        static let focus = "Focus"
        static let shortBreak = "Short Break"
        static let longBreak = "Long Break"
    }

    enum Progress {
        static func complete(_ percent: Int) -> String { "\(percent)% complete" }
    }
}
