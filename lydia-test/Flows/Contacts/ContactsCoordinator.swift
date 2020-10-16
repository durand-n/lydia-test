//
//  ContactsCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

class ContactsCoordinator: BaseCoordinator {
    private let factory: ContactsModuleFactory
    private let router: Router
    private let viewModel = ContactsViewModel()
    
    init(factory: ContactsModuleFactory, router: Router) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        showContactsList()
    }
    
    func showContactsList() {
        let module = factory.makeContactsListController(viewModel: viewModel)
        module.onShowDetails =  { [weak self] in
            self?.showContactsDetails()
        }
        self.router.push(module)
    }
    
    func showContactsDetails() {

    }
}
