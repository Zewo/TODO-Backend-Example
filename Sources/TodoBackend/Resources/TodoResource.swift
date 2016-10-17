import HTTPServer

struct TodoResource : Resource {
    let store: TodoStore
    let middleware: [Middleware] = [ContentNegotiationMiddleware(mediaTypes: [.json])]

    // GET / (get all todos)
    func list(request: Request) throws -> Response {
        let todos = store.getAll()
        return try Response(content: todos)
    }

    // POST / (create a new todo)
    func create(request: Request, content todo: Todo) throws -> Response {
        let inserted = store.insert(todo: todo)
        return try Response(content: inserted)
    }

    // GET /:id (get a todo)
    func detail(request: Request, id: Int) throws -> Response {
        guard let todo = store.get(id: id) else {
            return Response(status: .notFound)
        }
        return try Response(content: todo)
    }

    // PATCH /:id (modify a todo)
    func update(request: Request, id: Int, content update: Map) throws -> Response {
        guard let oldTodo = store.get(id: id) else {
            return Response(status: .notFound)
        }
        let newTodo = store.update(id: id, todo: oldTodo.item.update(map: update))
        return try Response(content: newTodo)
    }

    // DELETE /:id (delete a todo)
    func destroy(request: Request, id: Int) throws -> Response {
        guard let removed = store.remove(id: id) else {
            return Response(status: .noContent)
        }
        return try Response(content: removed)
    }

    // DELETE / (delete all todos)
    func clear(request: Request) throws -> Response {
        let deleted = store.clear()
        return try Response(content: deleted)
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
