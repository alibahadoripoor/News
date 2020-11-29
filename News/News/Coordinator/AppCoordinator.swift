//
//  AppCoordinator.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: class{
    var childCoordinators: [CoordinatorProtocol] { get }
    func start()
}

final class AppCoordinator: CoordinatorProtocol{
    private(set) var childCoordinators: [CoordinatorProtocol] = []
    
    private let window: UIWindow
    private let dataController = DataController(modelName: "NewsDataModel")
    private let webService = NewsWebService()
    
    init(window: UIWindow) {
        self.window = window
        dataController.load()
    }
    
    func start(){
        let navigationController = UINavigationController()
        let categoriesCoordinator = CategoriesCoordinator(navigationController: navigationController)
        categoriesCoordinator.dataController = dataController
        categoriesCoordinator.webService = webService
        childCoordinators.append(categoriesCoordinator)
        categoriesCoordinator.start()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
