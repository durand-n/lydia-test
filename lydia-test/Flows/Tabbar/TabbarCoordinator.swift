//
//  TabbarCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 15/10/2020.
//

import UIKit

protocol TabbarProtocol {
    
}

class TabbarCoordinator: BaseCoordinator, TabbarProtocol {
    // MARK: protocol compliance
    
    // MARK: attributes
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()
    private let tabbarModule: TabbarView = TabbarController()
    
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
                
            }
        }

        router.setRootModule(tabbarModule)
    }

    
    
    // MARK: contacts flow
    private func startContactsFlow(navigationController: UINavigationController) {
        let contactsCoordinator = coordinatorFactory.makeContactsCoordinator(navigationController: navigationController, factory: moduleFactory)
        addChild(contactsCoordinator)
        
        contactsCoordinator.start()
    }
    
    // MARK: Favorites flow
    private func startFavoritesFlow(navigationController: UINavigationController) {
    
    }
}

