//
//  ToDoListView.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject private var viewModel: ToDoListViewModel

    init(viewModel: ToDoListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.state {
                case .loading:
                    Text("Loading")

                case .empty:
                    ContentUnavailableView(
                        imageName: "text.badge.xmark",
                        title: "No item",
                        message: "Tap the Add button to create an item"
                    )

                case .filled(let filledData):
                    itemList(items: filledData.toDoItems)
                }
            }
        }
        .navigationTitle("Todos")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showNewToDoForm()
                } label: {
                    Text("Add")
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAllItems()
            }
        }
    }

    func itemList(items: [ToDoItem]) -> some View {
        List {
            ForEach(items, id: \.id) { item in
                HStack {
                    CheckMark(isChecked: item.completed) { isChecked in
                        viewModel.updateItem(id: item.id, isCompleted: isChecked)
                    }
                    Text(item.name)
                }
            }
            .onDelete(perform: delete)
        }
    }

    func delete(at offsets: IndexSet) {
        Task {
            await viewModel.remove(atOffsets: offsets)
        }
    }
}

struct CheckMark: View {
    private let isChecked: Bool
    private let action: (Bool) -> Void

    init(isChecked: Bool, action: @escaping (Bool) -> Void) {
        self.isChecked = isChecked
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.action(!isChecked)
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
        }
    }
}

#Preview {
    ToDoListView(
        viewModel: ToDoListViewModel(
            appRouter: AppRouterMock(),
            toDoRepository: InMemoryToDoRepository()
        )
    )
}
