//
//  Untitled.swift
//  TraktDevelope
//
//  Created by navid zare on 13/11/25.
//
import SwiftUI

struct SearchView: View {
    @State private var query = ""
    @State private var results: [TMDBItem] = []
    @State private var isLoading = false
    @State private var error: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Native searchable on the nav bar (iOS 15+)
            // If you prefer inline, use a TextField instead.
            List {
                if isLoading {
                    ProgressView("Searching…")
                } else if let error {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Couldent find any thing").font(.headline)
                        Text(error).foregroundStyle(.secondary)
                    }
                } else if results.isEmpty && !query.isEmpty {
                    Text("No results for “\(query)”")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(results) { item in
                        HStack(spacing: 12) {
                            AsyncImage(url: TMDBService().imageURL(path: item.poster_path)) { phase in
                                switch phase {
                                case .empty: Color.gray.opacity(0.1)
                                case .success(let image): image.resizable().scaledToFill()
                                case .failure: Color.gray.opacity(0.1)
                                @unknown default: Color.clear
                                }
                            }
                            .frame(width: 60, height: 90)
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                            
                            Text(item.displayTitle)
                                .font(.body)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .automatic))
        .onSubmit(of: .search) {
            Task { await performSearch() }
        }
        .onChange(of: query) { _, newValue in
            // Optional: live search after short delay/debounce
        }
    }
    
    @MainActor
    private func performSearch() async {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return }
        
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            let items = try await TMDBService().searchMovies(query: q)
            self.results = items
        } catch {
            self.error = error.localizedDescription
            self.results = []
        }
    }
}
