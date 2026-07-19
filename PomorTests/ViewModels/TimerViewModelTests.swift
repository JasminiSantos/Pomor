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
            engine: DefaultPomodoroEngine()
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
}
