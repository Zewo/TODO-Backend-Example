//
//  Todo.swift
//  TODOBackend
//
//  Created by Dan Appel on 5/1/16.
//
//

import Mapper
import Resource

struct Todo {
    let id: Int?
    let url: String?
    let title: String
    let completed: Bool
    let order: Int
}

extension Todo {
    func modify(id: Int? = nil, url: String? = nil, title: String? = nil, completed: Bool? = nil, order: Int? = nil) -> Todo {
        return self.dynamicType.init(
            id: id ?? self.id,
            url: url ?? self.url,
            title: title ?? self.title,
            completed: completed ?? self.completed,
            order: order ?? self.order
        )
    }

    func modify(content: StructuredData) -> Todo {
        return self.modify(
            id: content.get(optional: "id"),
            url: content.get(optional: "url"),
            title: content.get(optional: "title"),
            completed: content.get(optional: "completed"),
            order: (content.get(optional: "order") as Double?).map(Int.init)
        )
    }
}

extension Todo: ContentMappable {}

extension Todo: Mappable {
    init(mapper: Mapper) throws {
        try self.init(
            id: mapper.map(optionalFrom: "id"),
            url: mapper.map(optionalFrom: "url"),
            title: mapper.map(from: "title"),
            completed: mapper.map(optionalFrom: "completed") ?? false,
            order: (mapper.map(optionalFrom: "order") as Double?).map(Int.init) ?? 0
        )
    }
}

extension Todo: StructuredDataRepresentable {
    var structuredData: StructuredData {
        return [
           "id": id.map { .infer($0) } ?? nil,
           "title": .infer(title),
           "url": url.map { .infer($0) } ?? nil,
           "completed": .infer(completed),
           "order": .infer(order)
        ]
    }
}
