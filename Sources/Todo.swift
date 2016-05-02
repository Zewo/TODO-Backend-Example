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

extension Todo: ContentMappable {}

extension Todo: Mappable {
    init(mapper: Mapper) throws {
        try self.init(
            id: mapper.map(optionalFrom: "id"),
            url: mapper.map(optionalFrom: "url"),
            title: mapper.map(from: "title"),
            completed: mapper.map(optionalFrom: "completed") ?? false,
            order: mapper.map(optionalFrom: "order") ?? 0
        )
    }
}

extension Todo: StructuredDataRepresentable {
    var structuredData: StructuredData {
        return [
           "id": id.map { .from($0) } ?? nil,
           "title": .from(title),
           "url": url.map { .from($0) } ?? nil,
           "completed": .from(completed),
           "order": .from(order)
        ]
    }
}
