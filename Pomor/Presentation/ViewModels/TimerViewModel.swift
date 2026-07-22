import PomorCore
import PomorDesignSystem
import SwiftUI
import Combine

final class TimerViewModel: ObservableObject {
    
    let task: PomTask
    
    @Published var timeRemaining: Int
    @Published var isRunning: Bool = false
    @Published var state: TimerState = .focus
    
    private var totalTime: Int
    private var cycleCount: Int = 0
    private var sessionObservation: Task<Void, Never>?
    
    private let timerService: TimerService
    private let engine: PomodoroEngine
    private let liveActivity: LiveActivityManaging
    
    var formattedTime: String {
        let minutes = timeRemaining/60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    init(
        task: PomTask,
        timerService: TimerService,
        engine: PomodoroEngine,
        liveActivity: LiveActivityManaging
    ) {
        self.task = task
        self.timerService = timerService
        self.engine = engine
        self.liveActivity = liveActivity
        
        if let session = liveActivity.currentSession(for: task.id) {
            self.state = session.state
            self.totalTime = session.phaseDuration
            self.timeRemaining = session.secondsRemaining
            self.cycleCount = session.cycleCount
            self.isRunning = session.isRunning
        } else {
            let duration = task.duration * 60
            self.totalTime = duration
            self.timeRemaining = duration
        }

        if isRunning {
            resumeTicker()
        }

        observeLiveActivitySession()
    }

    deinit {
        sessionObservation?.cancel()
    }
    
    var progress: Double {
        1 - (Double(timeRemaining)/Double(totalTime))
    }
    
    func start() {
        guard !isRunning else { return }
        
        isRunning = true
        liveActivity.start(
            task: task,
            state: state,
            secondsRemaining: timeRemaining,
            phaseDuration: totalTime,
            cycleCount: cycleCount
        )
        resumeTicker()
    }
    
    func stop() {
        guard isRunning else { return }
        isRunning = false
        timerService.stop()
        liveActivity.update(
            state: state,
            secondsRemaining: timeRemaining,
            phaseDuration: totalTime,
            cycleCount: cycleCount,
            isRunning: false
        )
    }
    
    func toggle() {
        isRunning ? stop() : start()
    }
    
    func reset() {
        if isRunning {
            isRunning = false
            timerService.stop()
        }
        state = .focus
        cycleCount = 0
        
        let duration = task.duration * 60
        totalTime = duration
        timeRemaining = duration
        liveActivity.end()
    }
    
    private func resumeTicker() {
        timerService.start(interval: 1) { [weak self] in
            self?.tick()
        }
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            handleFinish()
        }
    }
    
    private func handleFinish() {
        let result = engine.nextState(
            current: state,
            cycleCount: cycleCount,
            taskDuration: task.duration
        )
        
        state = result.state
        totalTime = result.duration
        timeRemaining = result.duration
        cycleCount = result.cycle
        
        liveActivity.update(
            state: state,
            secondsRemaining: timeRemaining,
            phaseDuration: totalTime,
            cycleCount: cycleCount,
            isRunning: true
        )
    }

    private func observeLiveActivitySession() {
        sessionObservation?.cancel()
        sessionObservation = Task { [weak self] in
            guard let self else { return }
            for await session in liveActivity.sessionUpdates(for: task.id) {
                await MainActor.run {
                    self.applyRemoteSession(session)
                }
            }
        }
    }

    func syncFromLiveActivity() {
        guard let session = liveActivity.currentSession(for: task.id) else { return }
        applyRemoteSession(session)
    }

    private func applyRemoteSession(_ session: TimerSessionSnapshot) {
        state = session.state
        totalTime = session.phaseDuration
        timeRemaining = session.secondsRemaining
        cycleCount = session.cycleCount

        if session.isRunning == isRunning { return }

        if session.isRunning {
            isRunning = true
            resumeTicker()
        } else {
            isRunning = false
            timerService.stop()
        }
    }
}

extension TimerViewModel {
    
    var backgroundColor: Color {
        switch state {
        case .focus:      return PomorColor.Timer.focusSoft
        case .shortBreak: return PomorColor.Timer.shortBreakSoft
        case .longBreak:  return PomorColor.Timer.longBreakSoft
        }
    }
    
    var stateTitle: String {
        switch state {
        case .focus:      return TimerStrings.State.focus
        case .shortBreak: return TimerStrings.State.shortBreak
        case .longBreak:  return TimerStrings.State.longBreak
        }
    }
}
