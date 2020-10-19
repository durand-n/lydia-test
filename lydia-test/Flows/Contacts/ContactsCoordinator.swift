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
    
    init(factory: ContactsModuleFactory, router: Router) {
        self.router = router
        self.factory = factory
    }
    
    override func start() {
        showContactsList()
    }
    
    func showContactsList() {
        let module = factory.makeContactsListController(viewModel: ContactsListViewModel())
        module.onShowDetails =  { [weak self] user in
            self?.showContactsDetails(user: user)
        }
        
        module.onPhone = { [weak self] number in
            self?.call(number: number)
        }
    
        
        self.router.push(module)
    }
    
    func showContactsDetails(user: User) {
        let module = factory.makeContactsDetailsController(viewModel: ContactsDetailsViewModel(user: user))
        module.onPhone = { [weak self] number in
            self?.call(number: number)
        }
        
        self.router.push(module)
    }
    
    func call(number: String) {
        self.router.openUrl(url: URL(string: "tel://\(number)"))
    }
}
