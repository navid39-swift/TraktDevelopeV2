//
//  ContentView.swift
//  TraktDevelope
//
//  Created by navid zare on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var vm = TrendingViewModel()
    @StateObject private var newReleasesVM = NewReleasesViewModel()
    @StateObject private var upcomingVM = UpcomingViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 16) {
                Text("welcome to Trakt")
                    .font(.title2).fontWeight(.semibold)
                    .buttonStyle(.glass)

                NavigationLink {
                    DetailView()
                } label: {
                    HStack(spacing: 8) {
                        
                        Text("Trending Shows & Movies")
                            .font(.headline)
                        Image(systemName: "sparkles.tv.fill")
                        
                    }
                    
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial) // glass look
                    .clipShape(Capsule())           // rounded capsule
                    .overlay(Capsule().stroke(.separator, lineWidth: 0.5)) // light border
                    .shadow(radius: 4, y: 2)        // soft floating effect
                }
                .buttonStyle(.plain)
                .foregroundColor(.primary)
                Spacer()
                Group {
                    if vm.isLoading && vm.items.isEmpty {
                        ProgressView().frame(height: 220)
                    } else if let err = vm.error, vm.items.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Failed to Load").font(.headline)
                            Text(err).font(.subheadline).foregroundColor(.secondary)
                            Button("Retry") { Task { await vm.reload() } }
                        }
                        .frame(height: 220, alignment: .leading)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 1) {
                                ForEach(vm.items) { item in
                                    VStack(alignment: .leading, spacing: 8) {
                                        AsyncImage(url: vm.posterURL(for: item)) { phase in
                                            switch phase {
                                            case .empty:
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.gray.opacity(0.12))
                                                    ProgressView()
                                                }
                                            case .success(let image):
                                                image.resizable().scaledToFill()
                                            case .failure:
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.gray.opacity(0.12))
                                                    Image(systemName: "photo")
                                                        .font(.title2).foregroundColor(.secondary)
                                                }
                                            @unknown default:
                                                Color.clear
                                            }
                                        }
                                        .frame(width: 140, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                        Text(item.displayTitle)
                                            .font(.subheadline)
                                            .lineLimit(1)
                                            .buttonStyle(.glass)
                                        Button {
                                            LibraryStorage.shared.add(item)
                                        } label: {
                                            Label("Add", systemImage: "plus")
                                                .font(.caption)
                                        }
                                        .buttonStyle(.bordered)

                                    }
                                    .frame(width: 140, alignment: .leading)
                                    .containerRelativeFrame(.horizontal, count: 2, spacing: 90)
                                }
                                
                            }
                            .padding(.leading, 1)
                            .scrollTargetLayout()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 5)
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .frame(height: 240)
                    }
                    Spacer()
                    // New Releases header
                    HStack {
                       
                        NavigationLink {
                            // TODO: Push to a full list screen for new releases if you have one
                            DetailView()
                        } label: {
                            HStack(spacing: 8) {
                                
                                Text("New Release Shows").font(.headline)
                                Image(systemName: "movieclapper.fill")
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(.separator, lineWidth: 0.5))
                            .shadow(radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.primary)
                        
                    }
                    Spacer()

                    // New Releases content
                    Group {
                        if newReleasesVM.isLoading && newReleasesVM.items.isEmpty {
                            ProgressView().frame(height: 220)
                        } else if let err = newReleasesVM.error, newReleasesVM.items.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Failed to Load New Releases").font(.headline)
                                Text(err).font(.subheadline).foregroundColor(.secondary)
                                Button("Retry") { Task { await newReleasesVM.reload() } }
                            }
                            .frame(height: 220, alignment: .leading)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 4) {
                                    ForEach(newReleasesVM.items) { item in
                                        VStack(alignment: .leading, spacing: 8) {
                                            AsyncImage(url: newReleasesVM.posterURL(for: item)) { phase in
                                                switch phase {
                                                case .empty:
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(Color.gray.opacity(0.12))
                                                        ProgressView()
                                                    }
                                                case .success(let image):
                                                    image.resizable().scaledToFill()
                                                case .failure:
                                                    ZStack {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(Color.gray.opacity(0.12))
                                                        Image(systemName: "photo")
                                                            .font(.title2).foregroundColor(.secondary)
                                                    }
                                                @unknown default:
                                                    Color.clear
                                                }
                                            }
                                            .frame(width: 140, height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                            Text(item.displayTitle)
                                                .font(.subheadline)
                                                .lineLimit(1)
                                            
                                            Button {
                                                LibraryStorage.shared.add(item)
                                            } label: {
                                                Label("Add", systemImage: "plus")
                                                    .font(.caption)
                                            }
                                            .buttonStyle(.bordered)
                                        }
                                        .frame(width: 140, alignment: .leading)
                                        .containerRelativeFrame(.horizontal, count: 2, spacing: 90) // 2 per snap page
                                    }
                                }
                                .padding(.leading, 1)  // breathing room for the first page
                                .scrollTargetLayout()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 5)
                            }
                            .scrollTargetBehavior(.viewAligned)
                            .frame(height: 240)
                        }
                        Spacer()
                        // Upcoming header
                        HStack {
                           
                            NavigationLink {
                                DetailView() // or a dedicated Upcoming screen
                            } label: {
                                HStack(spacing: 4) {
                                    
                                    Text("Upcoming Shows&Movies").font(.headline)
                                    Image(systemName: "calendar")
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(.ultraThinMaterial)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(.separator, lineWidth: 0.5))
                                .shadow(radius: 4, y: 2)
                            }
                            .buttonStyle(.plain)
                            .foregroundColor(.primary)
                        }
                        Spacer()

                        // Upcoming content
                        Group {
                            if upcomingVM.isLoading && upcomingVM.items.isEmpty {
                                ProgressView().frame(height: 220)
                            } else if let err = upcomingVM.error, upcomingVM.items.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Failed to Load Upcoming").font(.headline)
                                    Text(err).font(.subheadline).foregroundColor(.secondary)
                                    Button("Retry") { Task { await upcomingVM.reload() } }
                                }
                                .frame(height: 220, alignment: .leading)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 4) {
                                        ForEach(upcomingVM.items) { item in
                                            VStack(alignment: .leading, spacing: 8) {
                                                AsyncImage(url: upcomingVM.posterURL(for: item)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .fill(Color.gray.opacity(0.12))
                                                            ProgressView()
                                                        }
                                                    case .success(let image):
                                                        image.resizable().scaledToFill()
                                                    case .failure:
                                                        ZStack {
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .fill(Color.gray.opacity(0.12))
                                                            Image(systemName: "photo")
                                                                .font(.title2).foregroundColor(.secondary)
                                                        }
                                                    @unknown default:
                                                        Color.clear
                                                    }
                                                }
                                                .frame(width: 140, height: 200)
                                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                                Text(item.displayTitle)
                                                    .font(.subheadline)
                                                    .lineLimit(1)
                                                Button {
                                                    LibraryStorage.shared.add(item)
                                                } label: {
                                                    Label("Add", systemImage: "plus")
                                                        .font(.caption)
                                                }
                                                .buttonStyle(.bordered)
                                            }
                                            .frame(width: 140, alignment: .leading)
                                            .containerRelativeFrame(.horizontal, count: 2, spacing: 90) // 2 per snap page
                                        }
                                    }
                                    .padding(.leading, 4)
                                    .scrollTargetLayout()
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 5)
                                }
                                .scrollTargetBehavior(.viewAligned)
                                .frame(height: 240)
                            }
                        }
                        
                        
                        
                    }
                }

                
            }
            .task { await vm.loadIfNeeded()
                await newReleasesVM.loadIfNeeded()
                await upcomingVM.loadIfNeeded()
            }
            .padding(.top, 40)
            .padding(.horizontal, 5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .navigationBarTitleDisplayMode(.large)
            
        }
    }
}

#Preview { HomeView() }
