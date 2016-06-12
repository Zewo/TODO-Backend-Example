// Todo.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Mapper
import Resource

struct Todo {
    let title: String
    let completed: Bool
    let order: Int
}

extension Todo {
    func update(title: String? = nil, completed: Bool? = nil, order: Int? = nil) -> Todo {
        return self.dynamicType.init(
            title: title ?? self.title,
            completed: completed ?? self.completed,
            order: order ?? self.order
        )
    }

    func update(content: StructuredData) -> Todo {
        return self.update(
            title: content.get(optional: "title"),
            completed: content.get(optional: "completed"),
            order: content.get(optional: "order")
        )
    }
}

extension Todo: ContentMappable, StructuredDataConvertible {
    init(mapper: Mapper) throws {
        try self.init(
            title: mapper.map(from: "title"),
            completed: mapper.map(optionalFrom: "completed") ?? false,
            order: mapper.map(optionalFrom: "order") ?? 0
        )
    }

    var structuredData: StructuredData {
        return [
           "title": .infer(title),
           "completed": .infer(completed),
           "order": .infer(order)
        ]
    }
}
