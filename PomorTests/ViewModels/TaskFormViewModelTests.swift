import XCTest
@testable import Pomor

@MainActor
final class TaskFormViewModelTests: XCTestCase {
    
    var repository: MockTaskRepository!
    var viewModel: TaskFormViewModel!
    
    override func setUp() {
        super.setUp()
        repository = MockTaskRepository()
        viewModel = makeSut()
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    private func makeSut(mode: TaskFormMode = .create) -> TaskFormViewModel {
        TaskFormViewModel(
            mode: mode,
            addTaskUseCase: AddTaskUseCase(repository: repository),
            updateTaskUseCase: UpdateTaskUseCase(repository: repository)
        )
    }
    
    func test_init_create_setsDefaultValues() {
        XCTAssertEqual(viewModel.selectedIcon, .target)
        XCTAssertEqual(viewModel.durationText, "25")
    }

    func test_init_edit_setsTaskValues() {
        let task = Task(id: UUID(), title: "Study", duration: 30, icon: "book")
        viewModel.mode = .edit(task)
        
        XCTAssertEqual(viewModel.title, "Study")
        XCTAssertEqual(viewModel.durationText, "30")
        XCTAssertEqual(viewModel.selectedIcon, .book)
    }
    
    func test_isValid_false_whenTitleEmpty() {
        viewModel.title = ""
        viewModel.durationText = "25"
        viewModel.selectedIcon = .book
        
        XCTAssertFalse(viewModel.isValid)
    }

    func test_isValid_false_whenDurationInvalid() {
        viewModel.title = "Study"
        viewModel.durationText = "abc"
        viewModel.selectedIcon = .book
        
        XCTAssertFalse(viewModel.isValid)
    }
    
    func test_isValid_true_whenAllValid() {
        viewModel.title = "Study"
        viewModel.durationText = "25"
        viewModel.selectedIcon = .book
        
        XCTAssertTrue(viewModel.isValid)
    }
    
    func test_selectDuration_setsValue() {
        viewModel.selectDuration(30)
        
        XCTAssertEqual(viewModel.durationText, "30")
    }

    func test_selectDuration_togglesOff() {
        viewModel.durationText = "25"
        
        viewModel.selectDuration(25)
        
        XCTAssertEqual(viewModel.durationText, "")
    }

    func test_onDurationTextChanged_filtersNonNumbers() {
        viewModel.onDurationTextChanged("25abc")
        
        XCTAssertEqual(viewModel.durationText, "25")
    }

    func test_selectIcon_setsIcon() {
        viewModel.selectIcon(.book)
        
        XCTAssertEqual(viewModel.selectedIcon, .book)
    }
    
    func test_save_create_success_savesTask_andCallsOnSuccess() {
        viewModel.title = "Study"
        viewModel.durationText = "25"
        viewModel.selectedIcon = .book
        
        var successCalled = false
        viewModel.onSuccess = { successCalled = true }
        
        viewModel.save()
        
        XCTAssertEqual(repository.tasks.count, 1)
        XCTAssertEqual(repository.tasks.first?.title, "Study")
        XCTAssertEqual(repository.tasks.first?.icon, "book")
        XCTAssertTrue(successCalled)
    }

    func test_save_create_failure_showsError() {
        viewModel.title = "Study"
        viewModel.durationText = "25"
        viewModel.selectedIcon = .book
        
        repository.errorToReturn = FakeError()
        
        viewModel.save()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_save_edit_success_updatesTask() {
        let task = Task(id: UUID(), title: "Old", duration: 25, icon: "book")
        repository.tasks = [task]
        
        viewModel.mode = .edit(task)
        viewModel.title = "New"
        viewModel.durationText = "30"
        viewModel.selectedIcon = .brain
        
        viewModel.save()
        
        XCTAssertEqual(repository.tasks.first?.title, "New")
        XCTAssertEqual(repository.tasks.first?.duration, 30)
        XCTAssertEqual(repository.tasks.first?.icon, "brain")
    }
    
    func test_save_edit_failure_showsError() {
        let task = Task(id: UUID(), title: "Old", duration: 25, icon: "book")
        
        viewModel.title = "New"
        viewModel.durationText = "30"
        viewModel.selectedIcon = .brain
        
        repository.errorToReturn = FakeError()
        
        viewModel.save()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_save_invalid_showsValidationError() {
        viewModel.title = ""
        
        viewModel.save()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, "Title is required")
    }
}
