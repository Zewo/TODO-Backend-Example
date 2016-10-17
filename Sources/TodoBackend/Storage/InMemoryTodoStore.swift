final class InMemoryTodoStore : TodoStore {
    private var idCounter = 0
    private var storage = [Int:Entity<Todo>]()

    func getAll() -> [Entity<Todo>] {
        return Array(storage.values)
    }

    func get(id: Int) -> Entity<Todo>? {
        return storage[id]
    }

    func insert(todo: Todo) -> Entity<Todo> {
        defer { idCounter += 1 }
        let entity = Entity(id: idCounter, item: todo)
        storage[idCounter] = entity
        return entity
    }

    func update(id: Int, todo: Todo) -> Entity<Todo> {
        let entity = Entity(id: id, item: todo)
        storage[id] = entity
        return entity
    }

    func remove(id: Int) -> Entity<Todo>? {
        defer { storage[id] = nil }
        return storage[id]
    }

    func clear() -> [Entity<Todo>] {
        defer { self.storage = [:] }
        return Array(storage.values)
    }
}
