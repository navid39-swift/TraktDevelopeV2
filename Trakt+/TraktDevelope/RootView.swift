//
//  RootView.swift
//  TraktDevelope
//
//  Created by navid zare on 09/11/25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            
            NavigationStack {            // ← put Navigation here
                HomeView()
            }
            
            .tabItem {
                
                Image(systemName: "play.tv.fill")
                Text("Movie Time")
                
            }
            .tag(0)
            NavigationStack {
                SearchView()
                    .navigationTitle("Search")
            }
            
            .tabItem {
                Image(systemName: "magnifyingglass.circle.fill")
                Text("Search")
                
            }
            
            .tag(1)
            NavigationStack {
                LibraryView()
                    .navigationTitle("Library")
            }
            .tabItem {
                Image(systemName: "film.stack")
                Text("Library")
            }
            .tag(2)
        }
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
        
        
}
#Preview { RootView() }
