//
//  LibraryView.swift
//  TraktDevelope
//
//  Created by navid zare on 13/11/25.
//
import SwiftUI
import Combine

struct LibraryView: View {
    @StateObject private var lvm = LibraryViewModel()

    var body: some View {
        Group {
            if lvm.items.isEmpty {
                ContentUnavailableView("Add Some Movie :)",
                                       systemImage: "film.stack",
                                       description: Text("Save Any Mobie You Want To Watch."))
                    .padding()
            } else {
                List {
                    ForEach(lvm.items) { item in
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

                            Spacer()

                            // Remove from library
                            Button {
                                lvm.remove(item)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    .onDelete { indexSet in
                        lvm.remove(atOffsets: indexSet)
                    }
                }
                .listStyle(.plain)
            }
        }
        .task { await lvm.load() } // load on appear
    }
}
