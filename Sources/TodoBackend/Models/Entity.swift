import Axis

struct Entity<Item : MapConvertible> {
    let id: Int
    let url: String
    let item: Item

    init(id: Int, url: String? = nil, item: Item) {
        self.id = id
        self.url = url ?? "\(apiRoot)\(id)"
        self.item = item
    }
}

extension Entity : MapConvertible {
    func asMap() throws -> Map {
        var dict = try item.asMap().asDictionary()
        dict["id"] = Map(id)
        dict["url"] = Map(url)
        return Map(dict)
    }

    init(map: Map) throws {
        try self.init(
            id: map.get("id"),
            url: map.get("url"),
            item: map.get()
        )
    }
}
