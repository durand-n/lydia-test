//
//  CoordinatorFactory.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

protocol CoordinatorFactory {
    func makeTabBarCoordinator(coordinatorFactory: CoordinatorFactory, router: Router) -> BaseCoordinator & TabbarProtocol
    
    func makeContactsCoordinator(navigationController: UINavigationController, factory: ContactsModuleFactory) -> BaseCoordinator
}
