//
//  CoordinatorFactory.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit
import CoreData

protocol CoordinatorFactory {
    func makeTabBarCoordinator(coordinatorFactory: CoordinatorFactory, router: Router) -> BaseCoordinator & TabbarProtocol
    
    func makeContactsCoordinator(navigationController: UINavigationController, factory: ContactsModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator
    
    func makeFavoritesCoordinator(navigationController: UINavigationController, factory: FavoritesModuleFactory, dataManager: DataManagerProtocol) -> BaseCoordinator
}
