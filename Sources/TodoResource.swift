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

import Resource
import JSONMediaType

func makeTodoResource(store todoStore: TodoStore) -> Resource {

    return Resource(mediaTypes: JSONMediaType()) { todo in

        // GET / (get all todos)
        todo.get { request in
            let todos = todoStore.getAll()
            return Response(content: todos.structuredData)
        }

        // POST / (create a new todo)
        todo.post { (request: Request, todo: Todo) in
            let inserted = todoStore.insert(todo: todo)
            return Response(content: inserted)
        }

        // DELETE / (delete all todos)
        todo.delete { request in
            let deleted = todoStore.clear()
            return Response(content: deleted.structuredData)
        }

        // GET /:id (get a todo)
        todo.get { (request: Request, id: Int) in
            guard let todo = todoStore.get(id: id) else {
                return Response(status: .notFound)
            }
            return Response(content: todo)
        }

        // PATCH /:id (modify a todo)
        todo.patch { (request: Request, id: Int, update: StructuredData) in
            guard let oldTodo = todoStore.get(id: id) else {
                return Response(status: .notFound)
            }
            let newTodo = todoStore.update(id: id, todo: oldTodo.item.update(content: update))
            return Response(content: newTodo)
        }

        // DELETE /:id (delete a todo)
        todo.delete { (request: Request, id: Int) in
            guard let removed = todoStore.remove(id: id) else {
                return Response(status: .noContent)
            }
            return Response(content: removed)
        }

        // OPTIONS /
        todo.options { request in
            return Response(headers: [
                "Access-Control-Allow-Headers": "accept, content-type",
                "Access-Control-Allow-Methods": "OPTIONS,GET,POST,DELETE"
            ])
        }

        // OPTIONS /:id
        todo.options("/:id") { request in
            return Response(headers: [
                 "Access-Control-Allow-Headers": "accept, content-type",
                 "Access-Control-Allow-Methods": "OPTIONS,GET,PATCH,DELETE"
            ])
        }
    }
}
