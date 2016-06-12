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
    func get(id: Int) -> Entity<Todo>?
    func getAll() -> [Entity<Todo>]

    func insert(todo: Todo) -> Entity<Todo>

    func update(id: Int, todo: Todo) -> Entity<Todo>

    func remove(id: Int) -> Entity<Todo>?
    func clear() -> [Entity<Todo>]
}

final class InMemoryTodoStore: TodoStore {
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
        let entity = Entity(id: idCounter, url: "\(apiRoot)\(idCounter)", item: todo)
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
