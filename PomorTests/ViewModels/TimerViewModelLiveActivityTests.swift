import Foundation
import PomorCore
import Testing
@testable import Pomor

@MainActor
struct TimerViewModelLiveActivityTests {

    private let task = PomTask(
        id: UUID(),
        title: "Study",
        duration: 25,
        icon: "book"
    )

    @Test func start_requestsLiveActivityWithCurrentSession() {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)

        sut.start()

        #expect(liveActivity.startCalls.count == 1)
        #expect(liveActivity.startCalls[0].taskId == task.id)
        #expect(liveActivity.startCalls[0].state == .focus)
        #expect(liveActivity.startCalls[0].secondsRemaining == 1500)
        #expect(liveActivity.startCalls[0].phaseDuration == 1500)
        #expect(liveActivity.startCalls[0].cycleCount == 0)
        #expect(liveActivity.activeTaskId == task.id)
    }

    @Test func stop_updatesLiveActivityAsPaused() {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)

        sut.start()
        sut.timeRemaining = 1200
        sut.stop()

        #expect(liveActivity.updateCalls.count == 1)
        #expect(liveActivity.updateCalls[0].isRunning == false)
        #expect(liveActivity.updateCalls[0].secondsRemaining == 1200)
        #expect(liveActivity.updateCalls[0].state == .focus)
    }

    @Test func reset_endsLiveActivity() {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)

        sut.start()
        sut.reset()

        #expect(liveActivity.endCallCount == 1)
        #expect(liveActivity.activeTaskId == nil)
        #expect(!sut.isRunning)
        #expect(sut.timeRemaining == 1500)
        #expect(sut.state == .focus)
    }

    @Test func init_restoresPausedSession() {
        let liveActivity = StubLiveActivityManager()
        liveActivity.sessionTaskId = task.id
        liveActivity.session = TimerSessionSnapshot(
            state: .longBreak,
            secondsRemaining: 400,
            phaseDuration: 900,
            cycleCount: 4,
            isRunning: false
        )

        let sut = makeSUT(liveActivity: liveActivity)

        #expect(sut.state == .longBreak)
        #expect(sut.timeRemaining == 400)
        #expect(!sut.isRunning)
        #expect(sut.progress == PomodoroSessionMetrics.progress(
            isRunning: false,
            endDate: Date(),
            secondsRemaining: 400,
            phaseDuration: 900
        ))
    }

    @Test func init_ignoresSessionFromAnotherTask() {
        let liveActivity = StubLiveActivityManager()
        liveActivity.sessionTaskId = UUID()
        liveActivity.session = TimerSessionSnapshot(
            state: .shortBreak,
            secondsRemaining: 60,
            phaseDuration: 300,
            cycleCount: 1,
            isRunning: true
        )

        let sut = makeSUT(liveActivity: liveActivity)

        #expect(sut.state == .focus)
        #expect(sut.timeRemaining == 1500)
        #expect(!sut.isRunning)
    }

    @Test func syncFromLiveActivity_appliesCurrentSession() {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)
        liveActivity.sessionTaskId = task.id
        liveActivity.session = TimerSessionSnapshot(
            state: .shortBreak,
            secondsRemaining: 180,
            phaseDuration: 300,
            cycleCount: 2,
            isRunning: false
        )

        sut.syncFromLiveActivity()

        #expect(sut.state == .shortBreak)
        #expect(sut.timeRemaining == 180)
        #expect(!sut.isRunning)
    }

    @Test
    func remotePause_stopsRunningTimer() async {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)

        sut.start()
        #expect(sut.isRunning)

        liveActivity.emit(
            TimerSessionSnapshot(
                state: .focus,
                secondsRemaining: 1400,
                phaseDuration: 1500,
                cycleCount: 0,
                isRunning: false
            )
        )
        await waitFor { !sut.isRunning }

        #expect(!sut.isRunning)
        #expect(sut.timeRemaining == 1400)
    }

    @Test
    func remoteResume_startsPausedTimer() async {
        let liveActivity = StubLiveActivityManager()
        let sut = makeSUT(liveActivity: liveActivity)

        liveActivity.emit(
            TimerSessionSnapshot(
                state: .focus,
                secondsRemaining: 1000,
                phaseDuration: 1500,
                cycleCount: 0,
                isRunning: true
            )
        )
        await waitFor { sut.isRunning }

        #expect(sut.isRunning)
        #expect(sut.timeRemaining == 1000)
    }

    private func makeSUT(liveActivity: LiveActivityManaging) -> TimerViewModel {
        TimerViewModel(
            task: task,
            timerService: DefaultTimerService(),
            engine: DefaultPomodoroEngine(),
            liveActivity: liveActivity
        )
    }

    private func waitFor(
        timeoutNanoseconds: UInt64 = 1_000_000_000,
        condition: @MainActor () -> Bool
    ) async {
        let start = DispatchTime.now().uptimeNanoseconds
        while !condition() {
            if DispatchTime.now().uptimeNanoseconds - start > timeoutNanoseconds {
                break
            }
            await Task.yield()
            try? await Task.sleep(nanoseconds: 5_000_000)
        }
    }
}
