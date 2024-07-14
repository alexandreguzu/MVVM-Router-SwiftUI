//
//  File.swift
//  MVVMAppRouter
//
//  Created by Alex on 30/06/2024.
//

import Foundation
import UIKit
import SwiftUI

protocol AppRouter {
    func start()
    func showNewToDoForm()
}

class AppRouterImpl: AppRouter {
    let window: UIWindow
    let topNavigationController: UINavigationController = UINavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let toDoListViewModel = ToDoListViewModel(appRouter: self, toDoRepository: InMemoryToDoRepository())
        let toDoListView = ToDoListView(viewModel: toDoListViewModel)

        let toDoListHostingController = UIHostingController(rootView: toDoListView)

        topNavigationController.setViewControllers([toDoListHostingController], animated: false)

        window.rootViewController = topNavigationController
        window.makeKeyAndVisible()
    }

    func showNewToDoForm() {
        let newToDoMainView = NewToDoMainView()
        let newToDoHostingController = UIHostingController(rootView: newToDoMainView)

        topNavigationController.present(newToDoHostingController, animated: true)
    }
}
