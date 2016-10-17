import Axis

struct Todo {
    let title: String
    let completed: Bool
    let order: Int
}

extension Todo {
    func update(title: String? = nil, completed: Bool? = nil, order: Int? = nil) -> Todo {
        return Todo.init(
            title: title ?? self.title,
            completed: completed ?? self.completed,
            order: order ?? self.order
        )
    }

    func update(map: Map) -> Todo {
        return self.update(
            title: map["title"].string,
            completed: map["completed"].bool,
            order: map["order"].int
        )
    }
}

extension Todo : MapConvertible {
    init(map: Map) throws {
        try self.init(
            title: map.get("title"),
            completed: map["completed"].bool ?? false,
            order: map["order"].int ?? 0
        )
    }
}
