import HTTPServer
import POSIX

// Configuration
let apiRoot = environment["API_ROOT"] ?? "http://127.0.0.1:8080/"

// Middleware
let cors = CORSMiddleware()
let log = LogMiddleware()

// Storage
let store = InMemoryTodoStore()

// Resources
let todoResource = TodoResource(store: store)

// Main router
let router = BasicRouter(middleware: [log, cors]) { route in
    route.compose("/", resource: todoResource)
}

// Server
try Server(responder: router).start()
