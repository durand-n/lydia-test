//
//  ContactsCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit
import CoreData
import ContactsUI

class ContactsCoordinator: BaseCoordinator {
    private let factory: ContactsModuleFactory
    private let router: Router
    private let dataManager: DataManagerProtocol
    
    init(factory: ContactsModuleFactory, router: Router, dataManager: DataManagerProtocol) {
        self.router = router
        self.factory = factory
        self.dataManager = dataManager
    }
    
    override func start() {
        showContactsList()
    }
    
    func showContactsList() {
        let module = factory.makeContactsListController(viewModel: ContactsListViewModel(dataManager: dataManager))
        module.onShowDetails =  { [weak self] user in
            self?.showContactsDetails(user: user)
        }
        
        module.onPhone = { [weak self] number in
            self?.call(number: number)
        }
    
        self.router.push(module)
    }
    
    func showContactsDetails(user: User) {
        let module = factory.makeContactsDetailsController(viewModel: ContactsDetailsViewModel(user: user, dataManager: dataManager))
        module.onPhone = { [weak self] number in
            self?.call(number: number)
        }
        
        module.onAdd = { [weak self] contact in
            let vc = CNContactViewController(forUnknownContact: contact)
            vc.contactStore = CNContactStore()
            vc.delegate = module.toPresent()
            vc.allowsActions = false
            (self?.router.toPresent() as? UINavigationController)?.pushViewController(vc, animated: true)
        }
            
        
        self.router.push(module)
    }
    
    func call(number: String) {
        self.router.openUrl(url: URL(string: "tel://\(number)"))
    }
    
}



