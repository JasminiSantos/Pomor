import Foundation
import PomorCore
import PomorDI
import SwiftUI
import Testing
@testable import Pomor

@MainActor
struct AppCoordinatorDeepLinkTests {

    @Test func handleDeepLink_home_clearsPathAndLeavesSplash() {
        let coordinator = makeCoordinator(tasks: [])

        coordinator.handleDeepLink(PomorDeepLink.home.url)

        #expect(coordinator.root == .home)
        #expect(coordinator.path.isEmpty)
    }

    @Test func handleDeepLink_timer_opensMatchingTask() {
        let task = PomTask(id: UUID(), title: "Sprint", duration: 25, icon: "flame")
        let coordinator = makeCoordinator(tasks: [task])

        coordinator.handleDeepLink(PomorDeepLink.timer(taskId: task.id).url)

        #expect(coordinator.root == .home)
        #expect(coordinator.path.count == 1)
    }

    @Test func handleDeepLink_timer_unknownTask_goesHome() {
        let coordinator = makeCoordinator(tasks: [])

        coordinator.handleDeepLink(PomorDeepLink.timer(taskId: UUID()).url)

        #expect(coordinator.root == .home)
        #expect(coordinator.path.isEmpty)
    }

    @Test func handleDeepLink_invalidURL_isIgnored() {
        let coordinator = makeCoordinator(tasks: [])
        let url = URL(string: "https://example.com")!

        coordinator.handleDeepLink(url)

        #expect(coordinator.root == .splash)
        #expect(coordinator.path.isEmpty)
    }

    @Test func goToTimer_replacesPathInsteadOfStacking() {
        let first = PomTask(id: UUID(), title: "A", duration: 25, icon: "a")
        let second = PomTask(id: UUID(), title: "B", duration: 15, icon: "b")
        let coordinator = makeCoordinator(tasks: [first, second])
        coordinator.finishSplash()

        coordinator.goToTimer(task: first)
        coordinator.goToTimer(task: second)

        #expect(coordinator.path.count == 1)
    }

    private func makeCoordinator(tasks: [PomTask]) -> AppCoordinator {
        let repository = MockTaskRepository()
        repository.tasks = tasks

        let container = DIContainer()
        container.register(GetTasksUseCase.self) { _ in
            GetTasksUseCase(repository: repository)
        }

        return AppCoordinator(container: container)
    }
}
