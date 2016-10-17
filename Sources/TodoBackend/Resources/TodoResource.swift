// TodoResource.swift
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

import HTTPServer

struct TodoResource : Resource {
    let store: TodoStore
    let middleware: [Middleware] = [ContentNegotiationMiddleware(mediaTypes: [.json])]

    // GET / (get all todos)
    func list(request: Request) throws -> Response {
        let todos = store.getAll()
        return Response(content: todos)
    }

    // POST / (create a new todo)
    func create(request: Request, content todo: Todo) throws -> Response {
        let inserted = store.insert(todo: todo)
        return Response(content: inserted)
    }

    // GET /:id (get a todo)
    func detail(request: Request, id: Int) throws -> Response {
        guard let todo = store.get(id: id) else {
            return Response(status: .notFound)
        }
        return Response(content: todo)
    }

    // PATCH /:id (modify a todo)
    func update(request: Request, id: Int, content update: Map) throws -> Response {
        guard let oldTodo = store.get(id: id) else {
            return Response(status: .notFound)
        }
        let newTodo = store.update(id: id, todo: oldTodo.item.update(map: update))
        return Response(content: newTodo)
    }

    // DELETE /:id (delete a todo)
    func destroy(request: Request, id: Int) throws -> Response {
        guard let removed = store.remove(id: id) else {
            return Response(status: .noContent)
        }
        return Response(content: removed)
    }

    // DELETE / (delete all todos)
    func clear(request: Request) throws -> Response {
        let deleted = store.clear()
        return Response(content: deleted)
    }

    func custom(routes: ResourceRoutes) {
        routes.delete(respond: clear)

        // OPTIONS /
        routes.options { request in
            return Response(headers: [
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST,DELETE"
            ])
        }

        // OPTIONS /:id
        routes.options("/:id") { request in
            return Response(headers: [
                "Access-Control-Allow-Methods": "OPTIONS,GET,PATCH,DELETE"
            ])
        }
    }
}
