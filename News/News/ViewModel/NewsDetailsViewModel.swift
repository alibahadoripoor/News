//
//  NewsDetailsViewModel.swift
//  News
//
//  Created by Ali Bahadori on 11.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

final class NewsDetailsViewModel {
    var coordinator: NewsDetailsCoordinator?
    
    func viewDidDisappear(){
        coordinator?.didFinishNewsDetailsViewController()
    }
    
    deinit {
        debugPrint("deinit from News Details ViewModel")
    }
}
