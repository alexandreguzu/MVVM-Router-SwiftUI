//
//  ToDoListViewModel.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import Foundation

@Observable
class ToDoListViewModel {

    enum UIState: Equatable {
        case loading
        case empty
        case filled(FilledData)

        struct FilledData: Equatable {
            let toDoItems: [ToDoItem]
            let error: String?
        }
    }

    private(set) var state: UIState = .loading

    @ObservationIgnored
    private let repository: ToDoRepository

    @ObservationIgnored
    private let appRouter: AppRouter

    init(appRouter: AppRouter, toDoRepository: ToDoRepository) {
        self.appRouter = appRouter
        self.repository = toDoRepository
    }

    @MainActor
    func fetchAllItems() async {
        let toDoItems = await repository.fetchAll()

        if toDoItems.isEmpty {
            state = .empty
        } else {
            state = .filled(UIState.FilledData(toDoItems: toDoItems, error: nil))
        }
    }

    @MainActor
    func addItem(name: String) async {
        if name.isEmpty { return }

        await repository.add(
            toDoItem: ToDoItem(
                name: name,
                completed: false
            )
        )

        await fetchAllItems()
    }

    @MainActor
    func remove(atOffsets indexSet: IndexSet) async {
        for index in indexSet {
            await repository.deleteItem(at: index)
        }
        await fetchAllItems()
    }

    func showNewToDoForm() {
        appRouter.showNewToDoForm()
    }
}
