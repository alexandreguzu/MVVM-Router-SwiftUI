//
//  ToDoListViewModel.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import Foundation

class ToDoListViewModel: ObservableObject {

    enum UIState: Equatable {
        case loading
        case empty
        case filled(FilledData)

        struct FilledData: Equatable {
            let toDoItems: [ToDoItem]
            let error: String?
        }
    }

    @Published private(set) var state: UIState = .loading

    private let repository: ToDoRepository

    private let appRouter: AppRouter

    init(appRouter: AppRouter, toDoRepository: ToDoRepository) {
        self.appRouter = appRouter
        self.repository = toDoRepository
    }

    func fetchAllItems() async {
        let toDoItems = await repository.fetchAll()

        Task { @MainActor in
            if toDoItems.isEmpty {
                state = .empty
            } else {
                state = .filled(UIState.FilledData(toDoItems: toDoItems, error: nil))
            }
        }
    }

    func addItem(item: ToDoItem) async {
        await repository.add(toDoItem: item)

        await fetchAllItems()
    }

    func remove(atOffsets indexSet: IndexSet) async {
        guard case .filled(let data) = state else { return }
        for index in indexSet {
            do {
                try await repository.delete(itemId: data.toDoItems[index].id)
            } catch {
                // TODO: handle error
                fatalError("Error not handled when deleting a todo item")
            }
        }
        await fetchAllItems()
    }

    func showNewToDoForm() {
        appRouter.showNewToDoForm(
            onNewToDo: { [weak self] toDoItem in
                guard let self else { return }

                Task {
                    await self.addItem(item: toDoItem)
                    self.appRouter.dismiss()
                }
            }, onCancel: { [weak self] in
                guard let self else { return }

                self.appRouter.dismiss()
            }
        )
    }

    func updateItem(id: String, isCompleted: Bool) {
        Task {
            do {
                try await repository.update(itemId: id, completed: isCompleted)
            } catch {
                // TODO: handle error
                fatalError("Error not handled when updating a todo item")
            }

            await fetchAllItems()
        }
    }
}
