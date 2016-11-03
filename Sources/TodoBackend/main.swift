import HTTPServer
import POSIX

// Configuration
let apiRoot = environment["API_ROOT"] ?? "http://localhost:8080/"
let usePq = environment["USE_POSTGRES"] == "true"
let pqHost = environment["POSTGRES_HOST"] ?? "localhost"
let pqPort = Int(environment["POSTGRES_PORT"] ?? "5432")!
let pqUser = environment["POSTGRES_USER"]
let pqPass = environment["POSTGRES_PASS"]

// Middleware
let cors = CORSMiddleware()
let log = LogMiddleware()

// Storage
let store: TodoStore = usePq
    ? try PostgreSQLTodoStore(info: .init(host: pqHost, port: pqPort, databaseName: "todo-backend", username: pqUser, password: pqPass))
    : InMemoryTodoStore()

// Resources
let todoResource = TodoResource(store: store, root: apiRoot)

// Main router
let router = BasicRouter(middleware: [log, cors]) { route in
    route.compose("/", resource: todoResource)
}

// Server
try Server(responder: router).start()
