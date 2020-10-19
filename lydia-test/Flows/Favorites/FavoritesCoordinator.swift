//
//  FavoritesCoordinator.swift
//  lydia-test
//
//  Created by Benoît Durand on 19/10/2020.
//

import UIKit
import CoreData
import ContactsUI

class FavoritesCoordinator: BaseCoordinator {
    private let factory: FavoritesModuleFactory
    private let router: Router
    private let dataManager: DataManagerProtocol
    
    init(factory: FavoritesModuleFactory, router: Router, dataManager: DataManagerProtocol) {
        self.router = router
        self.factory = factory
        self.dataManager = dataManager
    }
    
    override func start() {
        showFavorites()
    }
    
    func showFavorites() {
        let module = self.factory.makeFavoritesView(viewModel: FavoritesViewModel(dataManager: dataManager))
        
        module.onShowDetails =  { [weak self] user in
            self?.showContactsDetails(user: user)
        }
        
        self.router.push(module, animated: false)
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
