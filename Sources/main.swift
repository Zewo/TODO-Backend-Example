import Zewo

struct Todo: Mappable, StructuredDataRepresentable {
    var id: Int?
    var title: String?
    var url: String?
    var completed: Bool?
    var order: Int?
    
    init(mapper: Mapper) throws {
        self.id = mapper.map(optionalFrom: "id")
        self.title = mapper.map(optionalFrom: "title")
        self.url = mapper.map(optionalFrom: "url")
        self.completed = mapper.map(optionalFrom: "completed")
        self.order = mapper.map(optionalFrom: "order")
    }
    
    var structuredData: StructuredData {
        get {
            return [
               "id": StructuredData.from(id ?? 0),
               "title": StructuredData.from(title ?? ""),
               "url": StructuredData.from(url ?? ""),
               "completed": StructuredData.from(completed ?? false),
               "order": StructuredData.from(order ?? 0)
            ]
        }
    }
}

struct CorsMiddleware: Middleware {
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        var response = try chain.respond(to: request)
        response.headers.headers["access-control-allow-origin"] = Header("*")
        return response
    }
}

func getIdParameter(from request: Request) -> Int {
    guard let idString = request.pathParameters["id"] else { return 0 }
    return Int(idString) ?? 0
}

var todos = [Todo?]()

let listRouter = Router() { route in
    route.get("/") { request in
        var structuredTodos = [StructuredData]()
        for _todo in todos where _todo != nil {
            if let todo = _todo {
                structuredTodos.append(todo.structuredData)
            }
        }
        return Response(status: .ok, content: StructuredData.from(structuredTodos))
    }
    
    route.post("/") { request in
        guard let content = request.content else { return Response() }
        guard var todo = Todo.makeWith(structuredData: content) else { return Response() }
        
        todo.url = "http://localhost:34197/todo/\(todos.count)"
        todo.id = todos.count
        todos.append(todo)
        return Response(status: .ok, content: todo)
    }
    
    route.delete("/") { request in
        todos = [Todo?]()
        return Response()
    }
}

let todoRouter = Router() { route in
    route.get("/") { request in
        let index = getIdParameter(from:request)
        guard let todo: Todo = todos[index] else { return Response() }
        
        return Response(status: .ok, content: todo)
    }
    
    route.delete("/") { request in
        let index = getIdParameter(from:request)
        todos[index] = nil
        return Response()
    }
    
    route.patch("/") { request in
        let index = getIdParameter(from:request)
        guard let content = request.content else { return Response() }
        guard var todo = Todo.makeWith(structuredData: content) else { return Response() }
        
        todo.url = "http://localhost:34197/todo/\(index)"
        todo.completed = true
        todos[index] = todo
        return Response(status: .ok, content: todo)
    }
}

let contentNegotiationMiddleware = ContentNegotiationMiddleware(mediaTypes: [JSONMediaType()])
let router = Router(middleware: contentNegotiationMiddleware, CorsMiddleware()) { route in
    route.compose(path: "/", router: listRouter)
    route.compose(path: "/todo/:id", router: todoRouter)
}

try Server(on: 34197, responder: router).start()
