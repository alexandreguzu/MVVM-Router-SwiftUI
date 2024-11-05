//
//  ToDoListView.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject private var viewModel: ToDoListViewModel
    @State private var textInput: String = ""

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
                    Text("+")
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
                Text(item.name)
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

#Preview {
    ToDoListView(
        viewModel: ToDoListViewModel(
            appRouter: AppRouterMock(),
            toDoRepository: InMemoryToDoRepository()
        )
    )
}
