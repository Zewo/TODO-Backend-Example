//
//  TodoStore.swift
//  TODOBackend
//
//  Created by Dan Appel on 5/1/16.
//
//

protocol TodoStore {
    func nextId() -> Int

    func get(id: Int) -> Todo?
    func getAll() -> [Todo]

    func insert(todo: Todo, id: Int)

    func update(id: Int, todo: Todo) -> Todo

    func remove(id: Int) -> Todo?
    func clear() -> [Todo]
}

final class InMemoryTodoStore: TodoStore {
    private var idCounter = 0
    private var storage = [Int:Todo]()

    func getAll() -> [Todo] {
        return Array(storage.values)
    }

    func get(id: Int) -> Todo? {
        return self.storage[id]
    }

    func nextId() -> Int {
        defer { idCounter += 1 }
        return idCounter
    }

    func insert(todo: Todo, id: Int) {
        self.storage[id] = todo
    }

    func update(id: Int, todo: Todo) -> Todo {
        let new = Todo(id: id, url: todo.url, title: todo.title, completed: todo.completed, order: todo.order)

        self.storage[id] = new

        return new
    }

    func remove(id: Int) -> Todo? {
        let todo = storage[id]
        storage[id] = nil
        return todo
    }

    func clear() -> [Todo] {
        let deleted = storage.values
        self.storage = [:]
        return Array(deleted)
    }
}
