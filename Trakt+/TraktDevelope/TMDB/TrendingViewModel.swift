//
//  TrendingViewMdel.swift
//  TraktDevelope
//
//  Created by navid zare on 09/11/25.
//
import Foundation
import Combine

@MainActor
final class TrendingViewModel: ObservableObject {
    @Published var items: [TMDBItem] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service = TMDBService()

    func loadIfNeeded() async {
        await reload()
    }

    func reload() async {
        isLoading = true
        error = nil
        do {
            items = try await service.fetch(.trendingAllDay)
        } catch let err {
            self.error = err.localizedDescription
        }
        isLoading = false
    }

    func posterURL(for item: TMDBItem) -> URL? {
        service.imageURL(path: item.poster_path)
    }
}
