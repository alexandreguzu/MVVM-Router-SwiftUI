//
//  InMemoryToDoRepository.swift
//  MVVM
//
//  Created by Alex on 04/05/2024.
//

import Foundation

actor InMemoryToDoRepository: ToDoRepository {

    private var toDoItems: [ToDoItem] = []

    func fetchAll() async -> [ToDoItem] {
        return toDoItems
    }

    func add(toDoItem: ToDoItem) async {
        toDoItems.append(toDoItem)
    }

    func deleteItem(at index: Int) async {
        toDoItems.remove(at: index)
    }

    func updateCompleted(toDoItem: ToDoItem, completed: Bool) async throws {
        guard let index = toDoItems.firstIndex(where: { $0 == toDoItem }) else {
            throw ToDoRepositoryError.itemNotFound
        }
        toDoItems[index].completed = completed
    }
}
