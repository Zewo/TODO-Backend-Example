import SQL
import Axis

//TODO: Add to Zewo/SQL
extension PersistedEntity : MapConvertible {
    public init(map: Map) throws {
        try self.init(
            model: try Entity(map: map).model,
            primaryKey: map.get("id")
        )
    }

    public func asMap() throws -> Map {
        guard let primaryKey = primaryKey as? MapFallibleRepresentable else {
            throw MapError.notMapRepresentable(Model.PrimaryKey.self)
        }
        var dict = try Entity(model: model).asMap().asDictionary()
        dict["id"] = try primaryKey.asMap()
        return Map(dict)
    }
}

extension Entity : MapConvertible {
    public init(map: Map) throws {
        guard let model = Model.self as? MapInitializable.Type else {
            throw MapError.notMapInitializable(Model.self)
        }
        self = Entity(model: try model.init(map: map) as! Model)
    }

    public func asMap() throws -> Map {
        guard let model = model as? MapFallibleRepresentable else {
            throw MapError.notMapRepresentable(Model.self)
        }
        return try model.asMap()
    }
}
