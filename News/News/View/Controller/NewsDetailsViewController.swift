//
//  NewsDetailsViewController.swift
//  News
//
//  Created by Ali Bahadori on 11.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit
import SafariServices

class NewsDetailsViewController: SFSafariViewController{
    var viewModel: NewsDetailsViewModel!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    deinit {
        debugPrint("deinit from News Details VC")
    }
}
