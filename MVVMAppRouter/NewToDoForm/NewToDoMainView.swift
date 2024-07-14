//
//  NewToDoMainView.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import SwiftUI

struct NewToDoMainView: View {
    @State private var titleInput: String = ""
    @State private var descriptionInput: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $titleInput)
                    .textFieldStyle(.roundedBorder)

                TextField("Description", text: $descriptionInput)
                    .textFieldStyle(.roundedBorder)
            }
            .padding()
            .navigationTitle("New todo")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        print("Cancel tapped")
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        print("Next tapped")
                    }) {
                        Text("Next")
                    }
                }
            }
        }
    }
}

#Preview {
    NewToDoMainView()
}
