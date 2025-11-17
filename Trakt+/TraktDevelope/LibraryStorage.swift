//
//  Untitled.swift
//  TraktDevelope
//
//  Created by navid zare on 13/11/25.
//

import Foundation

final class LibraryStorage {
    static let shared = LibraryStorage()

    private(set) var items: [TMDBItem] = []

    func add(_ item: TMDBItem) {
        guard !items.contains(where: { $0.id == item.id }) else { return }
        items.append(item)
    }

    func remove(_ item: TMDBItem) {
        items.removeAll { $0.id == item.id }
    }

    func remove(atOffsets offsets: IndexSet) {
        for index in offsets.sorted(by: >) {
            if items.indices.contains(index) {
                items.remove(at: index)
            }
        }
    }

    func contains(_ item: TMDBItem) -> Bool {
        items.contains { $0.id == item.id }
    }
}
