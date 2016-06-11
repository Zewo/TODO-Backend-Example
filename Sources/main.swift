import HTTPServer
import Router
import LogMiddleware

// Middleware
let cors = CORSMiddleware()
let log = LogMiddleware(logger: Logger())

// Storage
let store = InMemoryTodoStore()

// Resources
let todoResource = makeTodoResource(store: store)

// Main router
let router = Router(middleware: cors) { route in
    route.compose("/todos", router: todoResource)
}

// Server
try Server(middleware: log, responder: router).start()
