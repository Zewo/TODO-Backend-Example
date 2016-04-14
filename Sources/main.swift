import HTTPServer
import Router
import JSON

func getIdParameter(from request: Request) -> Int {
    guard let idString = request.pathParameters["id"] else { return 0 }
    return Int(idString) ?? 0
}

let router = Router { route in

    var todos = [JSON?]()
    let corsHeader = Headers(["access-control-allow-origin" : Header(stringLiteral: "*")])
    
    route.get("/") { _ in
        var todooutput = ""
        for (index, _todo) in todos.enumerated() {
            if var todo = _todo where _todo != nil {
                if index > 0 { todooutput += "," }
                todooutput += JSONSerializer().serializeToString(todo)
            }
        }
        return Response(body: Data(stringLiteral: "[\(todooutput)]"), headers: corsHeader)
    }
    
    route.post("/") { request in
        switch request.body {
            case .buffer(let data):
                var json = try JSONParser().parse(data)
                json["url"] = JSON.from("http://localhost:34197/todo/\(todos.count)")
                json["completed"] = JSON.from(false)
                todos.append(json)
                return Response(body:Data(JSONSerializer().serializeToString(json)), headers: corsHeader)
            default: break
        }
        return Response(body:Data(), headers: corsHeader)
    }
    
    route.delete("/") { request in
        todos = [JSON?]()
        return Response(headers: corsHeader)
    }
    
    route.get("/todo/:id") { request in
        let index = getIdParameter(from:request)
        guard let todo: JSON = todos[index] else {
            return Response(body:Data(), headers: corsHeader)
        }
        return Response(body:Data(JSONSerializer().serializeToString(todo)), headers: corsHeader)
    }
    
    route.delete("/todo/:id") { request in
        let index = getIdParameter(from:request)
        todos[index] = nil
        return Response(body:Data(), headers: corsHeader)
    }

    route.patch("/todo/:id") { request in
        let index = getIdParameter(from:request)
        guard let todo: JSON = todos[index] else {
            return Response(body:Data(), headers: corsHeader)
        }
        switch request.body {
            case .buffer(let data):
                var json = try JSONParser().parse(data)
                json["url"] = JSON.from("http://localhost:34197/todo/\(index)")
                todos[index] = json
                return Response(body:Data(JSONSerializer().serializeToString(json)), headers: corsHeader)
            default: break
        }
        return Response(body: Data(), headers: corsHeader)
    }
}

try Server(on: 34197, responder: router).start()