import XCTest
@testable import Pomor

@MainActor
final class TaskListViewModelTests: XCTestCase {
    
    var viewModel: TaskListViewModel!
    var repository: MockTaskRepository!
    
    override func setUp() {
        super.setUp()
        
        repository = MockTaskRepository()
        
        let get = GetTasksUseCase(repository: repository)
        let delete = DeleteTaskUseCase(repository: repository)
        
        viewModel = TaskListViewModel(
            getTasksUseCase: get,
            deleteTaskUseCase: delete
        )
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        super.tearDown()
    }
    
    func test_loadTasks_success() {
        let task = Task(id: UUID(), title: "Study", duration: 25, icon: "book")
        repository.tasks = [task]
        
        viewModel.loadTasks()
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.title, "Study")
    }
    
    func test_loadTasks_empty() {
        repository.tasks = []
        
        viewModel.loadTasks()
        
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }
    
    func test_loadTasks_failure_setsErrorState() {
        repository.errorToReturn = FakeError()
        
        viewModel.loadTasks()
        
        XCTAssertTrue(viewModel.tasks.isEmpty)
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func test_deleteTask_success_removesTask() {
        let task = Task(id: UUID(), title: "Test", duration: 25, icon: "book")
        
        repository.tasks = [task]
        viewModel.loadTasks()
        
        viewModel.selectedTask = task
        viewModel.deleteTask()
        
        XCTAssertTrue(viewModel.tasks.isEmpty)
    }
    
    func test_deleteTask_failure_keepsTaskAndShowsError() {
        let task = Task(id: UUID(), title: "Test", duration: 25, icon: "book")
        
        repository.tasks = [task]
        viewModel.loadTasks()
        
        viewModel.selectedTask = task
        repository.errorToReturn = FakeError()
        
        viewModel.deleteTask()
        
        XCTAssertEqual(viewModel.tasks.count, 1)
        XCTAssertEqual(viewModel.tasks.first?.id, task.id)
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertNotNil(viewModel.errorMessage)
    }
}
