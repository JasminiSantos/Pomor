import Foundation
import PomorCore
import SwiftData

final class SwiftDataPersistentStore: TaskDataSource {
    let modelContainer: ModelContainer
    private var context: ModelContext { modelContainer.mainContext }

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    convenience init() throws {
        try self.init(modelContainer: ModelContainer(for: TaskEntity.self))
    }

    func fetchTasks() -> Result<[PomTask], Error> {
        run {
            try context
                .fetch(FetchDescriptor<TaskEntity>(sortBy: [SortDescriptor(\.title)]))
                .map { $0.toDomain() }
        }
    }

    func saveTask(_ task: PomTask) -> Result<Void, Error> {
        run {
            context.insert(TaskEntity(from: task))
            try context.save()
        }
    }

    func deleteTask(_ task: PomTask) -> Result<Void, Error> {
        run {
            guard let entity = try entity(id: task.id) else { throw TaskError.notFound }
            context.delete(entity)
            try context.save()
        }
    }

    func updateTask(_ task: PomTask) -> Result<Void, Error> {
        run {
            guard let entity = try entity(id: task.id) else { throw TaskError.notFound }
            entity.apply(task)
            try context.save()
        }
    }
}

private extension SwiftDataPersistentStore {
    func entity(id: UUID) throws -> TaskEntity? {
        var descriptor = FetchDescriptor<TaskEntity>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try context.fetch(descriptor).first
    }

    func run<T>(_ work: () throws -> T) -> Result<T, Error> {
        do {
            return .success(try work())
        } catch let error as TaskError {
            context.rollback()
            return .failure(error)
        } catch {
            context.rollback()
            return .failure(DataSourceError.persistenceFailed)
        }
    }
}
