import HTTP

struct CORSMiddleware : Middleware {
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        var response = try chain.respond(to: request)
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Headers"] = "accept, content-type"
        return response
    }
}
