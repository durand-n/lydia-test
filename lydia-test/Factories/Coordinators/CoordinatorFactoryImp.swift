//
//  CoordinatorFactoryImp.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

class CoordinatorFactoryImp: CoordinatorFactory {
    func makeContactsCoordinator(navigationController: UINavigationController, factory: ContactsModuleFactory) -> BaseCoordinator {
        return ContactsCoordinator(factory: factory, router: RouterImp(rootController: navigationController))
    }
    
    func makeTabBarCoordinator(coordinatorFactory: CoordinatorFactory, router: Router) -> BaseCoordinator & TabbarProtocol {
        return TabbarCoordinator(coordinatorFactory: coordinatorFactory, router: router)
    }
    
    // MARK: private
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImp(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController { return navController } else { return UINavigationController() }
    }
}
