import PomorCore
import Testing
import Foundation
@testable import Pomor

@MainActor
struct TaskListViewModelTests {

    let repository: MockTaskRepository
    let sut: TaskListViewModel

    init() {
        repository = MockTaskRepository()
        sut = TaskListViewModel(
            getTasksUseCase: GetTasksUseCase(repository: repository),
            deleteTaskUseCase: DeleteTaskUseCase(repository: repository),
            changeNotifier: MockTasksChangeNotifier()
        )
    }

    // MARK: - Load Tasks

    @Test func loadTasks_success() {
        let task = PomTask(id: UUID(), title: "Study", duration: 25, icon: "book")
        repository.tasks = [task]

        sut.loadTasks()

        #expect(sut.tasks.count == 1)
        #expect(sut.tasks.first?.title == "Study")
    }

    @Test func loadTasks_empty() {
        repository.tasks = []

        sut.loadTasks()

        #expect(sut.tasks.isEmpty)
    }

    @Test func loadTasks_failure_setsErrorState() {
        repository.errorToReturn = FakeError()

        sut.loadTasks()

        #expect(sut.tasks.isEmpty)
        #expect(sut.showError)
        #expect(sut.errorMessage != nil)
    }

    // MARK: - Delete Task

    @Test func deleteTask_success_removesTask() {
        let task = PomTask(id: UUID(), title: "Test", duration: 25, icon: "book")
        repository.tasks = [task]
        sut.loadTasks()

        sut.selectedTask = task
        sut.deleteTask()

        #expect(sut.tasks.isEmpty)
    }

    @Test func deleteTask_failure_keepsTaskAndShowsError() {
        let task = PomTask(id: UUID(), title: "Test", duration: 25, icon: "book")
        repository.tasks = [task]
        sut.loadTasks()

        sut.selectedTask = task
        repository.errorToReturn = FakeError()

        sut.deleteTask()

        #expect(sut.tasks.count == 1)
        #expect(sut.tasks.first?.id == task.id)
        #expect(sut.showError)
        #expect(sut.errorMessage != nil)
    }
}
