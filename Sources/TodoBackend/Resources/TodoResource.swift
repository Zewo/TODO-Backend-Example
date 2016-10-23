import HTTPServer

struct TodoResource : Resource {
    let store: TodoStore
    let middleware: [Middleware]

    init(store: TodoStore, root: String) {
        // append todo's url to response content
        let url = TodoURLMiddleware(root: apiRoot)
        // convert map <-> json
        let contentNegotiation = ContentNegotiationMiddleware(mediaTypes: [.json])
        self.middleware = [contentNegotiation, url]
        self.store = store
    }

    // GET / (get all todos)
    func list(request: Request) throws -> Response {
        let todos = try store.getAll()
        return try Response(content: todos)
    }

    // POST / (create a new todo)
    func create(request: Request, content todo: Todo) throws -> Response {
        let inserted = try store.insert(todo: todo)
        return try Response(content: inserted)
    }

    // GET /:id (get a todo)
    func detail(request: Request, id: Int) throws -> Response {
        guard let todo = try store.get(id: id) else {
            return Response(status: .notFound)
        }
        return try Response(content: todo)
    }

    // PATCH /:id (modify a todo)
    func update(request: Request, id: Int, content update: Map) throws -> Response {
        guard let oldTodo = try store.get(id: id) else {
            return Response(status: .notFound)
        }
        let newTodo = try store.update(id: id, todo: oldTodo.model.update(map: update))
        return try Response(content: newTodo)
    }

    // DELETE /:id (delete a todo)
    func destroy(request: Request, id: Int) throws -> Response {
        guard let removed = try store.remove(id: id) else {
            return Response(status: .noContent)
        }
        return try Response(content: removed)
    }

    // DELETE / (delete all todos)
    func clear(request: Request) throws -> Response {
        let deleted = try store.clear()
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
