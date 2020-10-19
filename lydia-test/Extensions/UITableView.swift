//
//  UITableView.swift
//  lydia-test
//
//  Created by Benoît Durand on 18/10/2020.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: name)) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>(withClass name: T.Type, reuseId: String) -> T {
        return dequeueReusableCell(withIdentifier: reuseId) as! T
    }
    
    func registerCellClass<T: UITableViewCell>(_ className: T.Type) {
        register(className, forCellReuseIdentifier: String(describing: className))
    }
    
}
