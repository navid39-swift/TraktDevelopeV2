import Foundation
import SwiftUI
import Combine

public struct LibraryItem: Identifiable, Hashable, Codable {
    public let id: Int
    public let title: String?
    public let name: String?
    public let poster_path: String?

    public init(id: Int, title: String? = nil, name: String? = nil, poster_path: String? = nil) {
        self.id = id
        self.title = title
        self.name = name
        self.poster_path = poster_path
    }

    public var displayTitle: String {
        title ?? name ?? "Untitled"
    }
}

public final class LibraryViewModel: ObservableObject {
    @Published public private(set) var items: [LibraryItem] = []

    public init() {}

    @MainActor
    public func load() async {
        // Simulate async loading. Replace with your real load logic.
        try? await Task.sleep(nanoseconds: 300_000_000)
       
    }

    public func remove(_ item: LibraryItem) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items.remove(at: idx)
        }
    }

    public func remove(atOffsets offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
}
