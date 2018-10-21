//
//  UIViewController+Extension.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, actionText: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionText, style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
