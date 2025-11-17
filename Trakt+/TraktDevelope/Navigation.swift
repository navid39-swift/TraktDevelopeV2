//
//  Navigation.swift
//  TraktDevelope
//
//  Created by navid zare on 08/11/25.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("This is where your eyes is")
                .font(.headline)
                .glassEffect()
            
        }
        .navigationTitle("movie")
        .navigationBarTitleDisplayMode(.inline)    // Smaller inline title
    }
}


