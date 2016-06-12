// TodoStore.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
