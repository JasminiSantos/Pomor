import Foundation
import PomorCore
import Testing

struct PomodoroSessionMetricsTests {

    @Test func progress_whenPaused_usesSecondsRemaining() {
        let progress = PomodoroSessionMetrics.progress(
            isRunning: false,
            endDate: Date(),
            secondsRemaining: 750,
            phaseDuration: 1500
        )

        #expect(abs(progress - 0.5) <= 0.001)
    }

    @Test func progress_whenRunning_usesEndDate() {
        let now = Date()
        let progress = PomodoroSessionMetrics.progress(
            isRunning: true,
            endDate: now.addingTimeInterval(300),
            secondsRemaining: 999,
            phaseDuration: 1000,
            now: now
        )

        #expect(abs(progress - 0.7) <= 0.001)
    }

    @Test func progress_clampsToZeroAndOne() {
        let now = Date()

        let finished = PomodoroSessionMetrics.progress(
            isRunning: true,
            endDate: now.addingTimeInterval(-10),
            secondsRemaining: 0,
            phaseDuration: 100,
            now: now
        )
        let full = PomodoroSessionMetrics.progress(
            isRunning: false,
            endDate: now,
            secondsRemaining: 100,
            phaseDuration: 100
        )

        #expect(finished == 1)
        #expect(full == 0)
    }

    @Test func percentComplete_roundsNearest() {
        let percent = PomodoroSessionMetrics.percentComplete(
            isRunning: false,
            endDate: Date(),
            secondsRemaining: 120,
            phaseDuration: 300
        )

        #expect(percent == 60)
    }

    @Test func stateTitle_mapsAllCases() {
        #expect(PomodoroSessionMetrics.stateTitle(for: .focus) == "Focus")
        #expect(PomodoroSessionMetrics.stateTitle(for: .shortBreak) == "Short Break")
        #expect(PomodoroSessionMetrics.stateTitle(for: .longBreak) == "Long Break")
    }

    @Test func formattedTime_padsMinutesAndSeconds() {
        #expect(PomodoroSessionMetrics.formattedTime(0) == "00:00")
        #expect(PomodoroSessionMetrics.formattedTime(65) == "01:05")
        #expect(PomodoroSessionMetrics.formattedTime(1500) == "25:00")
    }

    @Test func snapshot_progressAndPercent_matchPausedMetrics() {
        let snapshot = TimerSessionSnapshot(
            state: .focus,
            secondsRemaining: 900,
            phaseDuration: 1500,
            cycleCount: 1,
            isRunning: false
        )

        #expect(abs(snapshot.progress - 0.4) <= 0.001)
        #expect(snapshot.percentComplete == 40)
    }
}
