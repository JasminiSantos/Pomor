import PomorCore
import Testing
import Foundation
@testable import Pomor

@MainActor
struct TaskFormViewModelTests {

    let repository: MockTaskRepository
    let sut: TaskFormViewModel

    init() {
        repository = MockTaskRepository()
        sut = TaskFormViewModel(
            mode: .create,
            addTaskUseCase: AddTaskUseCase(repository: repository),
            updateTaskUseCase: UpdateTaskUseCase(repository: repository)
        )
    }

    private func switchToEditMode(task: PomTask) {
        sut.mode = .edit(task)
    }

    // MARK: - Init

    @Test func init_create_setsDefaultValues() {
        #expect(sut.selectedIcon == .target)
        #expect(sut.durationText == "25")
    }

    @Test func setupInitialData_edit_populatesFields() {
        let task = PomTask(id: UUID(), title: "Study", duration: 30, icon: "book")
        switchToEditMode(task: task)

        #expect(sut.title == "Study")
        #expect(sut.durationText == "30")
        #expect(sut.selectedIcon == .book)
    }

    // MARK: - Validation

    @Test func isValid_false_whenTitleEmpty() {
        sut.title = ""
        sut.durationText = "25"
        sut.selectedIcon = .book

        #expect(!sut.isValid)
    }

    @Test func isValid_false_whenDurationInvalid() {
        sut.title = "Study"
        sut.durationText = "abc"
        sut.selectedIcon = .book

        #expect(!sut.isValid)
    }

    @Test func isValid_true_whenAllValid() {
        sut.title = "Study"
        sut.durationText = "25"
        sut.selectedIcon = .book

        #expect(sut.isValid)
    }

    // MARK: - Duration

    @Test func selectDuration_setsValue() {
        sut.selectDuration(30)

        #expect(sut.durationText == "30")
    }

    @Test func selectDuration_togglesOff_whenSameValueSelected() {
        sut.durationText = "25"
        sut.selectDuration(25)

        #expect(sut.durationText == "")
    }

    @Test func onDurationTextChanged_filtersNonNumbers() {
        sut.onDurationTextChanged("25abc")

        #expect(sut.durationText == "25")
    }

    // MARK: - Icon

    @Test func selectIcon_setsIcon() {
        sut.selectIcon(.book)

        #expect(sut.selectedIcon == .book)
    }

    // MARK: - Save (Create)

    @Test func save_create_success_savesTask_andCallsOnSuccess() {
        sut.title = "Study"
        sut.durationText = "25"
        sut.selectedIcon = .book

        var successCalled = false
        sut.onSuccess = { successCalled = true }

        sut.save()

        #expect(repository.addTaskCallCount == 1)
        #expect(repository.tasks.first?.title == "Study")
        #expect(repository.tasks.first?.icon == "book")
        #expect(successCalled)
    }

    @Test func save_create_failure_showsError() {
        sut.title = "Study"
        sut.durationText = "25"
        sut.selectedIcon = .book
        repository.errorToReturn = FakeError()

        sut.save()

        #expect(sut.showError)
        #expect(sut.errorMessage != nil)
    }

    // MARK: - Save (Edit)

    @Test func save_edit_success_updatesTask() {
        let task = PomTask(id: UUID(), title: "Old", duration: 25, icon: "book")
        repository.tasks = [task]
        switchToEditMode(task: task)

        sut.title = "New"
        sut.durationText = "30"
        sut.selectedIcon = .brain

        sut.save()

        #expect(repository.updateTaskCallCount == 1)
        #expect(repository.tasks.first?.title == "New")
        #expect(repository.tasks.first?.duration == 30)
        #expect(repository.tasks.first?.icon == "brain")
    }

    @Test func save_edit_failure_showsError() {
        let task = PomTask(id: UUID(), title: "Old", duration: 25, icon: "book")
        switchToEditMode(task: task)

        sut.title = "New"
        sut.durationText = "30"
        sut.selectedIcon = .brain
        repository.errorToReturn = FakeError()

        sut.save()

        #expect(sut.showError)
        #expect(sut.errorMessage != nil)
    }

    // MARK: - Validation errors

    @Test func save_invalid_showsValidationError() {
        sut.title = ""

        sut.save()

        #expect(sut.showError)
        #expect(sut.errorMessage == "Title is required")
    }
}
