//
//  TMDBService.swift
//  TraktDevelope
//
//  Created by navid zare on 09/11/25.
//

import Foundation

enum TMDBError: Error {
    case badURL
    case badResponse
}


enum Feed {
    case trendingAllDay
    case nowPlayingMovies
    case upcomingMovies
    case popularMovies
}

final class TMDBService {
    private let apiKey = "67aaaa3c1f7019ad7bf87d94b2a6d6fd"
    private let imageBase = "https://image.tmdb.org/t/p/w500"
    
    private func url(for feed: Feed) -> URL? {
        switch feed {
        case .trendingAllDay:
            return URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(apiKey)")
        case .nowPlayingMovies:
            return URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        case .upcomingMovies:
            return URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)")
        case .popularMovies:
            return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")
        }
    }
    
    func fetch(_ feed: Feed) async throws -> [TMDBItem] {
        guard let url = url(for: feed) else { throw TMDBError.badURL }
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw TMDBError.badResponse }
        return try JSONDecoder().decode(TMDBTrendingResponse.self, from: data).results
    }
    
    func imageURL(path: String?) -> URL? {
        guard let p = path else { return nil }
        return URL(string: imageBase + p)
    }
}
// MARK: - Search
extension TMDBService {
    func searchMovies(query: String) async throws -> [TMDBItem] {
        guard
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(encoded)")
        else { throw TMDBError.badURL }
        
        let (data, resp) = try await URLSession.shared.data(from: url)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else { throw TMDBError.badResponse }
        return try JSONDecoder().decode(TMDBTrendingResponse.self, from: data).results
    }
}
