//
//  CORSMiddleware.swift
//  TODOBackend
//
//  Created by Dan Appel on 5/1/16.
//
//

import S4

struct CORSMiddleware: Middleware {
    func respond(to request: Request, chainingTo chain: Responder) throws -> Response {
        var response = try chain.respond(to: request)
        response.headers.headers["access-control-allow-origin"] = "*"
        return response
    }
}
