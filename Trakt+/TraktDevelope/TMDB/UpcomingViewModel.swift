//
//  UpcomingViewModel.swift
//  TraktDevelope
//
//  Created by navid zare on 13/11/25.
//


import Foundation
import Combine

@MainActor
final class UpcomingViewModel: ObservableObject {
    @Published var items: [TMDBItem] = []
    @Published var isLoading = false
    @Published var error: String?

    private let service = TMDBService()
    private var hasLoaded = false

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        await reload()
        hasLoaded = true
    }

    func reload() async {
        isLoading = true
        error = nil
        do {
            let results = try await service.fetch(.upcomingMovies)
            self.items = results
        } catch {
            self.error = error.localizedDescription
            self.items = []
        }
        isLoading = false
    }

    func posterURL(for item: TMDBItem) -> URL? {
        service.imageURL(path: item.poster_path)
    }
}
