//
//  NewsDetailsViewController.swift
//  News
//
//  Created by Ali Bahadori on 08.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//
import UIKit

final class NewsDetailsCoordinator: CoordinatorProtocol {
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    private let navigationController: UINavigationController
    
    var parentCoordinator: NewsCoordinator?
    
    var url: String!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let url = URL(string: url) else { return }
        let newsDetailsViewModel = NewsDetailsViewModel()
        newsDetailsViewModel.coordinator = self
        let newsDetailsViewController = NewsDetailsViewController(url: url)
        newsDetailsViewController.viewModel = newsDetailsViewModel
        navigationController.present(newsDetailsViewController, animated: true, completion: nil)
    }
    
    func didFinishNewsDetailsViewController(){
        parentCoordinator?.childDidFinish(self)
    }
    
    deinit {
        debugPrint("deinit from News Details Coordinator")
    }
}


