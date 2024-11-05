//
//  ContentUnavailableView.swift
//  MVVMAppRouter
//
//  Created by Alex on 14/07/2024.
//

import SwiftUI

struct ContentUnavailableView: View {
    var imageName: String
    var title: String
    var message: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentUnavailableView(
        imageName: "text.badge.xmark",
        title: "No item",
        message: "Tap the Add button to create an item"
    )
}
