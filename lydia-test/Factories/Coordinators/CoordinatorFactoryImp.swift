//
//  CoordinatorFactoryImp.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit
import CoreData

class CoordinatorFactoryImp: CoordinatorFactory {
    func makeFavoritesCoordinator(navigationController: UINavigationController, factory: FavoritesModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator {
        return FavoritesCoordinator(factory: factory, router: RouterImp(rootController: navigationController), dataManager: dataManager)
    }
    
    func makeContactsCoordinator(navigationController: UINavigationController, factory: ContactsModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator {
        return ContactsCoordinator(factory: factory, router: RouterImp(rootController: navigationController), dataManager: dataManager)
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
