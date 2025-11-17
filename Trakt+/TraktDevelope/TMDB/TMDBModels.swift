//
//  TMDBModels.swift
//  TraktDevelope
//
//  Created by navid zare on 09/11/25.
//

import Foundation

struct TMDBTrendingResponse: Decodable {
    let results: [TMDBItem]
}

struct TMDBItem: Identifiable, Decodable {
    let id: Int
    let title: String?
    let name: String?
    let poster_path: String?

    var displayTitle: String { title ?? name ?? "Untitled" }
}
