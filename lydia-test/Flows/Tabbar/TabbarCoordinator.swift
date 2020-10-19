//
//  TabbarCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 15/10/2020.
//

import UIKit
import CoreData

protocol TabbarProtocol {
    
}

class TabbarCoordinator: BaseCoordinator, TabbarProtocol {
    // MARK: protocol compliance
    
    // MARK: attributes
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()
    private let tabbarModule: TabbarView = TabbarController()
    private var dataManager = DataManager(container: NSPersistentContainer(name: "lydia_test"))
    
    // MARK: start functions
    init(coordinatorFactory: CoordinatorFactory, router: Router) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    public override func start() {
        
        // OnNewsletter click is called when tabbar module appear
        tabbarModule.onContactsClick = { navigationController in
            if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                self.startContactsFlow(navigationController: nc)
            }
        }
        
        tabbarModule.onContactsDoubleClick = { navigationController in
            if let nc = navigationController.toPresent() as? UINavigationController, let module = nc.viewControllers.first as? ContactsListView {
                module.scrollListToTop()
            }
        }
        
        tabbarModule.onFavoritesClick = { navigationController in
            if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                if let nc = navigationController.toPresent() as? UINavigationController, nc.viewControllers.isEmpty {
                    self.startFavoritesFlow(navigationController: nc)
                }
            }
        }

        router.setRootModule(tabbarModule)
    }

    
    
    // MARK: contacts flow
    private func startContactsFlow(navigationController: UINavigationController) {
        let contactsCoordinator = coordinatorFactory.makeContactsCoordinator(navigationController: navigationController, factory: moduleFactory, dataManager: dataManager)
        addChild(contactsCoordinator)
        
        contactsCoordinator.start()
    }
    
    // MARK: Favorites flow
    private func startFavoritesFlow(navigationController: UINavigationController) {
        let favoritesCoordinator = coordinatorFactory.makeFavoritesCoordinator(navigationController: navigationController, factory: moduleFactory, dataManager: dataManager)
        addChild(favoritesCoordinator)
        
        favoritesCoordinator.start()
    }
}

