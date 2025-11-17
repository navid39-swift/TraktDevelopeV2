//
//  GlassTheme.swift
//  TraktDevelope
//
//  Created by navid zare on 09/11/25.
//

import SwiftUI

// A background for the whole app so materials have something to blur
struct AppBackdrop: View {
    var body: some View {
        // pick your wallpaper / gradient
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

// MARK: - Reusable modifiers

struct GlassCard: ViewModifier {
    var corner: CGFloat = 16
    var material: Material = .thinMaterial

    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(material)
            .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(.separator, lineWidth: 0.5)
            )
            .shadow(radius: 6, y: 3)
    }
}

struct GlassPill: ViewModifier {
    var material: Material = .ultraThinMaterial
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(material)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.separator, lineWidth: 0.5))
            .shadow(radius: 4, y: 2)
    }
}

extension View {
    // Apply to cards/rows/sections
    func glassCard(corner: CGFloat = 16, material: Material = .thinMaterial) -> some View {
        modifier(GlassCard(corner: corner, material: material))
    }

    // Apply to small header chips
    func glassPill(material: Material = .ultraThinMaterial) -> some View {
        modifier(GlassPill(material: material))
    }

    // Global chrome: nav/tab bars get glass automatically
    func glassChrome() -> some View {
        self
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}
