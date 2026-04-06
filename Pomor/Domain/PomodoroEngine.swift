import Foundation

enum TimerState {
    case focus
    case shortBreak
    case longBreak
}

protocol PomodoroEngine {
    func nextState(
        current: TimerState,
        cycleCount: Int,
        taskDuration: Int
    ) -> (state: TimerState, duration: Int, cycle: Int)
}

final class DefaultPomodoroEngine: PomodoroEngine {
    
    func nextState(
        current: TimerState,
        cycleCount: Int,
        taskDuration: Int
    ) -> (state: TimerState, duration: Int, cycle: Int) {
        
        var cycle = cycleCount
        
        switch current {
            
        case .focus:
            cycle += 1
            
            if cycle % 4 == 0 {
                return (.longBreak, 15 * 60, cycle)
            } else {
                return (.shortBreak, 5 * 60, cycle)
            }
            
        case .shortBreak, .longBreak:
            return (.focus, taskDuration * 60, cycle)
        }
    }
}
