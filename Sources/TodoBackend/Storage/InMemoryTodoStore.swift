import SQL

final class InMemoryTodoStore : TodoStore {
    private var idCounter = 0
    private var storage = [Int:PersistedEntity<Todo>]()

    func getAll() -> [PersistedEntity<Todo>] {
        return Array(storage.values)
    }

    func get(id: Int) -> PersistedEntity<Todo>? {
        return storage[id]
    }

    func insert(todo: Todo) -> PersistedEntity<Todo> {
        defer { idCounter += 1 }
        let entity = PersistedEntity(model: todo, primaryKey: idCounter)
        storage[idCounter] = entity
        return entity
    }

    func update(id: Int, todo: Todo) -> PersistedEntity<Todo> {
        let entity = PersistedEntity(model: todo, primaryKey: id)
        storage[id] = entity
        return entity
    }

    func remove(id: Int) -> PersistedEntity<Todo>? {
        defer { storage[id] = nil }
        return storage[id]
    }

    func clear() -> [PersistedEntity<Todo>] {
        defer { self.storage = [:] }
        return Array(storage.values)
    }
}
