import Foundation
import Combine

@MainActor
final class TaskFormViewModel: ObservableObject {
    
    @Published var title: String = ""
    @Published var durationText: String = "25"
    @Published var selectedIcon: TaskIcon = .target
    
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    var onSuccess: (() -> Void)?
    
    let icons = TaskIcon.allCases
     
    var mode: TaskFormMode {
        didSet {
            setupInitialData()
        }
    }
    
    private let addTaskUseCase: AddTaskUseCase
    private let updateTaskUseCase: UpdateTaskUseCase
    
    init(
        mode: TaskFormMode,
        addTaskUseCase: AddTaskUseCase,
        updateTaskUseCase: UpdateTaskUseCase
    ) {
        self.mode = mode
        self.addTaskUseCase = addTaskUseCase
        self.updateTaskUseCase = updateTaskUseCase
    }
    
    var navigationTitle: String {
        switch mode {
        case .create: return "New Task"
        case .edit: return "Edit Task"
        }
    }
    
    var buttonTitle: String {
        switch mode {
        case .create: return "Create Task"
        case .edit: return "Save Changes"
        }
    }
    
    var duration: Int? {
        Int(durationText)
    }
    
    var selectedDuration: Int? {
        guard let value = Int(durationText),
              [15, 25, 30, 45].contains(value) else { return nil }
        return value
    }
    
    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        duration != nil
    }
    
    func selectDuration(_ value: Int) {
        if durationText == "\(value)" {
            durationText = ""
        } else {
            durationText = "\(value)"
        }
    }
    
    func onDurationTextChanged(_ value: String) {
        let filtered = value.filter { $0.isNumber }
        durationText = filtered
    }
    
    func selectIcon(_ icon: TaskIcon) {
        selectedIcon = icon
    }
    
    func save() {
        guard validate() else { return }
        
        let result: Result<Void, Error>
        
        switch mode {
        case .create:
            result = addTaskUseCase.execute(
                title: title,
                duration: duration ?? 25,
                icon: selectedIcon.rawValue
            )
            
        case .edit(let task):
            let updated = Task(
                id: task.id,
                title: title,
                duration: duration ?? 25,
                icon: selectedIcon.rawValue
            )
            result = updateTaskUseCase.execute(task: updated)
        }
        
        switch result {
        case .success:
            onSuccess?()
        case .failure(let error):
            handle(error)
        }
    }
    
    func setupInitialData() {
        if case let .edit(task) = mode {
            title = task.title
            durationText = "\(task.duration)"
            
            selectedIcon = TaskIcon(rawValue: task.icon) ?? .target
            
        } else {
            selectedIcon = .target
        }
    }
    
    
    private func validate() -> Bool {
        if title.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "Title is required"
            showError = true
            return false
        }
        
        guard duration != nil else {
            errorMessage = "Invalid duration"
            showError = true
            return false
        }
        
        return true
    }
    
    private func handle(_ error: Error) {
        errorMessage = error.localizedDescription
        showError = true
    }
}
