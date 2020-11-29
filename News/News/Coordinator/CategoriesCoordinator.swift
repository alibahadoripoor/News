//
//  CategoriesCoordinator.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

final class CategoriesCoordinator: CoordinatorProtocol{
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let navigationController: UINavigationController
    var dataController: DataController!
    var webService: NewsWebService!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let categoryListViewModel = CategoryListViewModel(dataController: dataController)
        categoryListViewModel.coordinator = self
        let categoriesTableViewController = CategoriesTableViewController()
        categoriesTableViewController.viewModel = categoryListViewModel
        navigationController.viewControllers = [categoriesTableViewController]
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func startNewsTableViewController(category: Category?, query: String?){
        let newsCoordinator = NewsCoordinator(navigationController: navigationController)
        newsCoordinator.webService = webService
        newsCoordinator.category = category
        newsCoordinator.query = query
        newsCoordinator.parentCoordinator = self
        childCoordinators.append(newsCoordinator)
        newsCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol){
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
}
