// Entity.swift
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

struct Entity<Item> where Item : MapInitializable, Item : MapRepresentable {
    let id: Int
    let url: String
    let item: Item

    init(id: Int, url: String? = nil, item: Item) {
        self.id = id
        self.url = url ?? "\(apiRoot)\(id)"
        self.item = item
    }
}

extension Entity : MapInitializable, MapRepresentable {
    var map: Map {
        var dict = item.map.dictionary!
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
