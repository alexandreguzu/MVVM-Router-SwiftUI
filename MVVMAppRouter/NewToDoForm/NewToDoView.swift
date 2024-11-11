//
//  NewToDoView.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import SwiftUI

struct NewToDoView: View {
    @State private var titleInput: String = ""
    @State private var descriptionInput: String = ""

    private let onNewToDo: (ToDoItem) -> Void
    private let onCancel: () -> Void

    init(
        onNewToDo: @escaping (ToDoItem) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.onNewToDo = onNewToDo
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $titleInput)
                    .textFieldStyle(.plain)
                    .font(.title2)

                TextField("Description", text: $descriptionInput)
                    .textFieldStyle(.plain)
                    .font(.title3)

                Spacer()
            }
            .padding()
            .navigationTitle("New todo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        onCancel()
                    } label: {
                        Text("Cancel")
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onNewToDo(ToDoItem(name: titleInput, completed: false))
                    } label: {
                        Text("Add")
                    }
                }
            }
        }
    }
}

#Preview {
    NewToDoView(onNewToDo: { _ in }, onCancel: {})
}
