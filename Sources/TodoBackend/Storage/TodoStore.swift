protocol TodoStore {
    func get(id: Int) -> Entity<Todo>?
    func getAll() -> [Entity<Todo>]

    func insert(todo: Todo) -> Entity<Todo>

    func update(id: Int, todo: Todo) -> Entity<Todo>

    func remove(id: Int) -> Entity<Todo>?
    func clear() -> [Entity<Todo>]
}
