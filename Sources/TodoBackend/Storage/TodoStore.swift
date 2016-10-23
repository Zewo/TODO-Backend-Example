import SQL

protocol TodoStore {
    func get(id: Int) throws -> PersistedEntity<Todo>?
    func getAll() throws -> [PersistedEntity<Todo>]

    func insert(todo: Todo) throws -> PersistedEntity<Todo>

    func update(id: Int, todo: Todo) throws -> PersistedEntity<Todo>

    func remove(id: Int) throws -> PersistedEntity<Todo>?
    func clear() throws -> [PersistedEntity<Todo>]
}
