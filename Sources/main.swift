import HTTPServer
import Router
import Resource
import JSONMediaType
import LogMiddleware
import StandardOutputAppender

//MARK: Middleware
let cors = CORSMiddleware()
let log = LogMiddleware(logger: Logger(name: "log", appender: StandardOutputAppender()))

//MARK: Storage
let store = InMemoryTodoStore()

//MARK: Resources
let todoResource = makeTodoResource(store: store)

//MARK: Main router
let router = Router(middleware: cors) { route in
    route.resources(path: "/", resources: todoResource)
}

//MARK: Server
try Server(middleware: log, responder: router).start()
