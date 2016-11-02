import HTTPServer
import POSIX

// Configuration
let apiRoot = environment["API_ROOT"] ?? "http://localhost:8080/"
let usePq = environment["USE_POSTGRESQL"] == "true"
let pqHost = environment["POSTGRESQL_HOST"] ?? "localhost"
let pqPort = Int(environment["POSTGRESQL_PORT"] ?? "5432")!

// Middleware
let cors = CORSMiddleware()
let log = LogMiddleware()

// Storage
let store: TodoStore = usePq
    ? try PostgreSQLTodoStore(info: .init(host: pqHost, port: pqPort, databaseName: "todo-backend"))
    : InMemoryTodoStore()

// Resources
let todoResource = TodoResource(store: store, root: apiRoot)

// Main router
let router = BasicRouter(middleware: [log, cors]) { route in
    route.compose("/", resource: todoResource)
}

// Server
try Server(responder: router).start()
