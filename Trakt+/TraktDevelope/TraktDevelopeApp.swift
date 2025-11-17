//
//  TraktDevelopeApp.swift
//  TraktDevelope
//
//  Created by navid zare on 08/11/25.
//

import SwiftUI

@main
struct TraktDevelopeApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                AppBackdrop()         // glass blur background
                RootView()            // tab bar + HomeView
            }
            .tint(.primary)
            .preferredColorScheme(.light)
        }
    }
}
