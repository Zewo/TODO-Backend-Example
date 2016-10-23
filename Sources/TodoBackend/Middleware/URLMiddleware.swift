import HTTP

struct TodoURLMiddleware : Middleware {
    let root: String

    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        var response = try chain.respond(to: request)
        response.content = response.content.map(inserted(in:))
        return response
    }

    // recursively search for "id" fields and append "url" field alongside them
    func inserted(in map: Map) -> Map {
        switch map {

        case let .array(array):
            return .array(array.map(inserted(in:)))

        case let .dictionary(dictionary):
            guard let component = try? map["id"].asString(converting: true) else {
                return map
            }
            var dictionary = dictionary
            dictionary["url"] = Map(root + component)
            return .dictionary(dictionary)

        default:
            return map
        }
    }
}
