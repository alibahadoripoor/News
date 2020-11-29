//
//  UIViewController + Extensions.swift
//  News
//
//  Created by Ali Bahadori on 04.11.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

extension UIViewController{
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
