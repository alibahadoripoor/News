//
//  NewsCoordinator.swift
//  News
//
//  Created by Ali Bahadori on 08.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

final class NewsCoordinator: CoordinatorProtocol {
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let navigationController: UINavigationController
    
    var webService: NewsWebService!
    var parentCoordinator: CategoriesCoordinator?
    
    var category: Category?
    var query: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let newsListViewModel = NewsListViewModel(webService: webService)
        newsListViewModel.coordinator = self
        newsListViewModel.category = category
        newsListViewModel.query = query
        let newsCollectionViewController = NewsCollectionViewController()
        newsCollectionViewController.viewModel = newsListViewModel
        navigationController.pushViewController(newsCollectionViewController, animated: true)
    }
    
    func presentNewsDetailsViewController(with url: String){
        let newsDetailsCoordinator = NewsDetailsCoordinator(navigationController: navigationController)
        newsDetailsCoordinator.url = url
        newsDetailsCoordinator.parentCoordinator = self
        childCoordinators.append(newsDetailsCoordinator)
        newsDetailsCoordinator.start()
    }
    
    func childDidFinish(_ childCoordinator: CoordinatorProtocol){
        if let index = childCoordinators.firstIndex(where: { coordinator -> Bool in
            return childCoordinator === coordinator
        }) {
            childCoordinators.remove(at: index)
        }
    }
    
    func didFinishNewsTableViewController(){
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        debugPrint("deinit from News Coordinator")
    }
}
