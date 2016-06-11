//
//  TodoResource.swift
//  TODOBackend
//
//  Created by Dan Appel on 5/1/16.
//
//

import Resource
import JSONMediaType

// MOVE TO STRUCTURED DATA
extension Sequence where Iterator.Element: StructuredDataRepresentable {
    public var structuredData: StructuredData {
        return .array(self.map { $0.structuredData })
    }
}

extension StructuredData {
    public func get<T>(optional: String) -> T? {
        return try? get(optional) as T
    }
}


func makeTodoResource(store todoStore: TodoStore) -> Resource {

    return Resource(mediaTypes: JSONMediaType()) { todo in

        // GET /
        todo.get { request in
            let todos = todoStore.getAll()
            return Response(content: todos.structuredData)
        }

        // POST /
        todo.post { (request: Request, todo: Todo) in
            let id = todoStore.nextId()
            let newTodo = todo.modify(id: id, url: "http://127.0.0.1:8080/todos/\(id)")
            todoStore.insert(todo: newTodo, id: id)
            return Response(content: newTodo)
        }

        // DELETE /
        todo.delete { request in
            let deleted = todoStore.clear()
            return Response(content: deleted.structuredData)
        }

        // GET /:id
        todo.get { (request: Request, id: Int) in
            guard let todo = todoStore.get(id: id) else {
                return Response(status: .notFound)
            }
            return Response(content: todo)
        }

        // PATCH /:id
        todo.patch { (request: Request, id: Int, update: StructuredData) in
            guard let oldTodo = todoStore.get(id: id) else {
                return Response(status: .notFound)
            }
            let newTodo = todoStore.update(id: id, todo: oldTodo.modify(content: update))
            return Response(content: newTodo)
        }

        // DELETE /:id
        todo.delete { (request: Request, id: Int) in
            guard let removed = todoStore.remove(id: id) else {
                return Response(status: .noContent)
            }
            return Response(content: removed)
        }

        // OPTIONS
        // /
        todo.options { request in
            return Response(headers: [
                "Access-Control-Allow-Headers": "accept, content-type",
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST,DELETE"
            ])
        }
        // /:id
        todo.options("/:id") { request in
            return Response(headers: [
                 "Access-Control-Allow-Headers": "accept, content-type",
                 "Access-Control-Allow-Methods": "OPTIONS,GET,PATCH,DELETE"
            ])
        }
    }
}
