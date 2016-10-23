import Axis
import PostgreSQL

class PostgreSQLTodoStore : TodoStore {
    let connection: Connection

    init(info: Connection.ConnectionInfo) throws {
        self.connection = Connection(info: info)
        try connection.open()
        try Todo.createTable(connection: connection)
    }

    deinit {
        connection.close()
    }

    func get(id: Int) throws -> PersistedEntity<Todo>? {
        return try Entity<Todo>.get(id, connection: connection)
    }

    func getAll() throws -> [PersistedEntity<Todo>] {
        return try Entity<Todo>.fetch(connection: connection)
    }

    func insert(todo: Todo) throws -> PersistedEntity<Todo> {
        return try Entity(model: todo).create(connection: connection)
    }

    func update(id: Int, todo: Todo) throws -> PersistedEntity<Todo> {
        guard var entity = try Entity<Todo>.get(id, connection: connection) else {
            // model does not exist yet
            //TODO: clean up
            //TODO: add to sql - upsert
            var values = todo.serialize()
            values[Todo.Field.primaryKey] = id
            let query = Todo.insert(values)
            try connection.execute(query)
            return try PersistedEntity(model: todo, primaryKey: id).refresh(connection: connection)
        }
        // model exists, update it
        entity.model = todo
        return try entity.save(connection: connection)
    }

    func remove(id: Int) throws -> PersistedEntity<Todo>? {
        //TODO: maybe make entity.delete return persistedentity?
        guard let entity = try Entity<Todo>.get(id, connection: connection) else {
            return nil
        }
        let deleted = try entity.delete(connection: connection)
        return PersistedEntity(model: deleted.model, primaryKey: id)
    }

    func clear() throws -> [PersistedEntity<Todo>] {
        let deleted = try getAll()
        try connection.execute(Todo.delete)
        return deleted
    }
}
