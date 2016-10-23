import Axis
import SQL

struct Todo {
    let title: String
    let completed: Bool
    let order: Int
}

extension Todo : ModelProtocol {
    typealias PrimaryKey = Int

    enum Field: String, ModelField {
        static let tableName = "todo"
        static let primaryKey = Field.id

        case id
        case title
        case completed
        // "order" is reserved in psql
        case order = "order_"
    }

    func serialize() -> [Field: ValueConvertible?] {
        return [
            .title: title,
            .completed: completed ? 1 : 0,
            .order: order
        ]
    }

    init<Row: RowProtocol>(row: TableRow<Todo, Row>) throws {
        try self.init(
            title: row.value(.title),
            completed: row.value(.completed) == 1,
            order: row.value(.order)
        )
    }
}

extension Todo {
    static func createTable<Connection : ConnectionProtocol>(connection: Connection) throws {
        //TODO: make a nice dsl for this in sql
        let query = "CREATE TABLE IF NOT EXISTS todo (" +
                        "id serial PRIMARY KEY NOT NULL," +
                        "title text NOT NULL," +
                        "completed integer NOT NULL DEFAULT 0," +
                        "order_ integer NOT NULL" +
                    ");"

        try connection.execute(query)
    }
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
