//
//  UIViewController.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

extension UIViewController {
    open func toPresent() -> UIViewController? {
        return self
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
