import XCTest
@testable import Pomor

final class TimerViewModelTests: XCTestCase {
    
    var viewModel: TimerViewModel!
    
    override func setUp() {
        super.setUp()
        
        let task = Task(id: UUID(), title: "Study", duration: 25, icon: "book")
        viewModel = TimerViewModel(task: task)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func test_initialState() {
        XCTAssertEqual(viewModel.timeRemaining, 1500)
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.progress, 0)
    }
    
    func test_start_setsIsRunningTrue() {
        viewModel.start()
        
        XCTAssertTrue(viewModel.isRunning)
    }
    
    func test_stop_setsIsRunningFalse() {
        viewModel.start()
        viewModel.stop()
        
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func test_toggle_startsWhenStopped() {
        viewModel.toggle()
        
        XCTAssertTrue(viewModel.isRunning)
    }

    func test_toggle_stopsWhenRunning() {
        viewModel.start()
        viewModel.toggle()
        
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func test_reset_stopsAndResetsTime() {
        viewModel.start()
        viewModel.timeRemaining = 100
        
        viewModel.reset()
        
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.timeRemaining, 1500)
    }
    
    func test_progress_calculation() {
        viewModel.timeRemaining = 750
        
        XCTAssertEqual(viewModel.progress, 0.5, accuracy: 0.001)
    }
    
    func test_start_doesNotStartTwice() {
        viewModel.start()
        let firstState = viewModel.isRunning
        
        viewModel.start()
        
        XCTAssertTrue(firstState)
        XCTAssertTrue(viewModel.isRunning)
    }
}
