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

extension Todo : MapInitializable, MapRepresentable {
    init(map: Map) throws {
        try self.init(
            title: map.get("title"),
            completed: map["completed"].bool ?? false,
            order: map["order"].int ?? 0
        )
    }

    var map: Map {
        return [
           "title": Map(title),
           "completed": Map(completed),
           "order": Map(order)
        ]
    }
}
