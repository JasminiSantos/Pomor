import PomorCore
import Testing
import Foundation
@testable import Pomor

struct TimerViewModelTests {

    let sut: TimerViewModel

    init() {
        let task = PomTask(id: UUID(), title: "Study", duration: 25, icon: "book")
        sut = TimerViewModel(
            task: task,
            timerService: DefaultTimerService(),
            engine: DefaultPomodoroEngine(),
            liveActivity: NoOpLiveActivityManager()
        )
    }

    @Test func initialState() {
        #expect(sut.timeRemaining == 1500)
        #expect(!sut.isRunning)
        #expect(sut.progress == 0)
    }

    @Test func start_setsIsRunningTrue() {
        sut.start()

        #expect(sut.isRunning)
    }

    @Test func stop_setsIsRunningFalse() {
        sut.start()
        sut.stop()

        #expect(!sut.isRunning)
    }

    @Test func toggle_startsWhenStopped() {
        sut.toggle()

        #expect(sut.isRunning)
    }

    @Test func toggle_stopsWhenRunning() {
        sut.start()
        sut.toggle()

        #expect(!sut.isRunning)
    }

    @Test func reset_stopsAndResetsTime() {
        sut.start()
        sut.timeRemaining = 100

        sut.reset()

        #expect(!sut.isRunning)
        #expect(sut.timeRemaining == 1500)
    }

    @Test func progress_calculation() {
        sut.timeRemaining = 750

        #expect(abs(sut.progress - 0.5) <= 0.001)
    }

    @Test func start_doesNotStartTwice() {
        sut.start()
        let firstState = sut.isRunning

        sut.start()

        #expect(firstState)
        #expect(sut.isRunning)
    }

    @Test func init_restoresSessionFromLiveActivity() {
        let task = PomTask(id: UUID(), title: "Study", duration: 25, icon: "book")
        let liveActivity = StubLiveActivityManager()
        liveActivity.session = TimerSessionSnapshot(
            state: .shortBreak,
            secondsRemaining: 120,
            phaseDuration: 300,
            cycleCount: 2,
            isRunning: true
        )

        let restored = TimerViewModel(
            task: task,
            timerService: DefaultTimerService(),
            engine: DefaultPomodoroEngine(),
            liveActivity: liveActivity
        )

        #expect(restored.state == .shortBreak)
        #expect(restored.timeRemaining == 120)
        #expect(restored.isRunning)
        #expect(abs(restored.progress - 0.6) <= 0.001)
    }

    @Test @MainActor
    func remotePause_fromLiveActivity_stopsTimer() async {
        let task = PomTask(id: UUID(), title: "Study", duration: 25, icon: "book")
        let liveActivity = StubLiveActivityManager()
        let timerService = DefaultTimerService()
        let viewModel = TimerViewModel(
            task: task,
            timerService: timerService,
            engine: DefaultPomodoroEngine(),
            liveActivity: liveActivity
        )

        viewModel.start()
        #expect(viewModel.isRunning)

        liveActivity.emit(
            TimerSessionSnapshot(
                state: .focus,
                secondsRemaining: 1400,
                phaseDuration: 1500,
                cycleCount: 0,
                isRunning: false
            )
        )

        await Task.yield()
        await Task.yield()

        #expect(!viewModel.isRunning)
        #expect(viewModel.timeRemaining == 1400)
    }
}
