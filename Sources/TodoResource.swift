//
//  TodoResource.swift
//  TODOBackend
//
//  Created by Dan Appel on 5/1/16.
//
//

import Resource
import JSONMediaType

func makeTodoResource(store todoStore: TodoStore) -> Resource {

    return Resource(mediaTypes: [JSONMediaType()]) { todo in

        // GET /
        todo.index { request in
            let todos = todoStore.getAll()
            return Response(content: todos.content)
        }

        // POST /
        todo.create(content: Todo.self) { request, todo in
            let id = todoStore.nextId()
            let newTodo = Todo(
                id: id,
                url: "http://01aa3281.ngrok.io/\(id)",
                title: todo.title, completed: todo.completed, order: todo.order)
            todoStore.insert(todo: newTodo, id: id)
            return Response(content: newTodo)
        }

        // DELETE /
        todo.clear { request in
            let deleted = todoStore.clear()
            return Response(content: deleted.content)
        }

        // GET /:id
        todo.show { request, id in
            guard let id = Int(id), todo = todoStore.get(id: id) else {
                return Response(status: .notFound)
            }
            return Response(content: todo)
        }

        // PUT /:id
        todo.update(content: Todo.self) { request, id, todo in
            guard let id = Int(id) else {
                return Response(status: .badRequest)
            }

            let newTodo = todoStore.update(id: id, todo: todo)
            return Response(content: newTodo)
        }

        // DELETE /:id
        todo.destroy { request, id in
            guard let id = Int(id) else {
                return Response(status: .badRequest)
            }
            guard let removed = todoStore.remove(id: id) else {
                return Response(status: .noContent)
            }
            return Response(content: removed)
        }
    }
}
