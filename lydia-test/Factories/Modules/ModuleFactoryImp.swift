//
//  ModuleFactoryImp.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation

final class ModuleFactoryImp {}

extension ModuleFactoryImp: ContactsModuleFactory {
    func makeContactsListController(viewModel: ContactsListViewModelType) -> ContactsListView {
        return ContactsListController(viewModel: viewModel)
    }
    
    func makeContactsDetailsController(viewModel: ContactsDetailsViewModelType) -> ContactsDetailsView {
        return ContactsDetailsController(viewModel: viewModel)
    }
}

extension ModuleFactoryImp: FavoritesModuleFactory {
    func makeFavoritesView(viewModel: FavoritesViewModelType) -> FavoritesView {
        return FavoritesController(viewModel: viewModel)
    }
}
