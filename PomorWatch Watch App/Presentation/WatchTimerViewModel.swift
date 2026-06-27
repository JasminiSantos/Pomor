
import Foundation
import Combine
import PomorCore

final class WatchTimerViewModel: ObservableObject {

    let task: PomTask

    @Published var timeRemaining: Int
    @Published var isRunning: Bool = false
    @Published var state: TimerState = .focus

    private var totalTime: Int
    private var cycleCount: Int = 0
    private var cancellable: AnyCancellable?

    private let config: PomodoroConfiguration

    init(task: PomTask, config: PomodoroConfiguration = PomodoroConfiguration()) {
        self.task = task
        self.config = config
        let duration = task.duration * 60
        self.totalTime = duration
        self.timeRemaining = duration
    }

    var formattedTime: String {
        String(format: "%02d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    var progress: Double {
        1 - Double(timeRemaining) / Double(totalTime)
    }

    var stateTitle: String {
        switch state {
        case .focus: return "Focus"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        cancellable = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    func stop() {
        isRunning = false
        cancellable?.cancel()
        cancellable = nil
    }

    func toggle() {
        isRunning ? stop() : start()
    }

    func reset() {
        stop()
        state = .focus
        cycleCount = 0
        let duration = task.duration * 60
        totalTime = duration
        timeRemaining = duration
    }

    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            handleFinish()
        }
    }

    private func handleFinish() {
        let cycle = cycleCount
        let engine = DefaultPomodoroEngine(config: config)
        let result = engine.nextState(current: state, cycleCount: cycle, taskDuration: task.duration)
        state = result.state
        totalTime = result.duration
        timeRemaining = result.duration
        cycleCount = result.cycle
        start()
    }
}
