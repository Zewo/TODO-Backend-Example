import PostgreSQL

final class PostgreSQLStore: TodoStore {
    
    let connection: PostgreSQL.Connection
    
    init(uri: URI) throws {
        connection = try PostgreSQL.Connection(uri)
    }
    
    func get(id: Int) -> Entity<Todo>? {
        do {
            guard let result = try SQL.Entity<Todo>.get(id, connection: connection), id = result.primaryKey else {
                return nil
            }
            
            return Entity<Todo>(id: id, item: result.model)
        }
        catch {
            return nil
        }
    }
    
    func getAll() -> [Entity<Todo>] {
        do {
            return try SQL.Entity<Todo>.fetchAll(connection: connection).flatMap {
                entity in
                
                guard let id = entity.primaryKey else {
                    return nil
                }
                
                return Entity<Todo>(id: id, item: entity.model)
            }
        }
        catch {
            return []
        }
    }
    
    func insert(todo: Todo) -> Entity<Todo> {
        do {
            let new = try SQL.Entity(model: todo).create(connection: connection)
            
            guard let id = new.primaryKey else {
                fatalError()
            }
            
            return Entity(id: id, item: new.model)
        }
        catch {
            fatalError("\(error)")
        }
    }
    
    func update(id: Int, todo: Todo) -> Entity<Todo> {
        do {
            try SQL.Entity<Todo>(model: todo, primaryKey: id).save(connection: connection)
            return Entity(id: id, item: todo)
        }
        catch {
            fatalError("\(error)")
        }
    }
    
    func remove(id: Int) -> Entity<Todo>? {
        do {
            guard let result = try SQL.Entity<Todo>.get(id, connection: connection) else {
                return nil
            }
            try result.delete(connection: connection)
            return nil
        }
        catch {
            return nil
        }
    }
    
    func clear() -> [Entity<Todo>] {
        
    }
    
}