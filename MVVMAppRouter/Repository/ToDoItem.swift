//
//  ToDoItem.swift
//  MVVM
//
//  Created by Alex on 04/05/2024.
//

import Foundation

struct ToDoItem: Identifiable, Equatable {
    var id: String { name }

    let name: String
    var completed: Bool
}
