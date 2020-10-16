//
//  AppCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

public class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let moduleFactory = ModuleFactoryImp()

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override public func start() {
       startContactsFlow()
    }

    private func startContactsFlow() {
        var tabBarCoordinator = coordinatorFactory.makeTabBarCoordinator(coordinatorFactory: coordinatorFactory, router: router)
        addChild(tabBarCoordinator)

        tabBarCoordinator.start()
    }

}
