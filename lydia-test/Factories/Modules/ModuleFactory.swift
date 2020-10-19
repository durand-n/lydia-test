//
//  ModuleFactory.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation



protocol ContactsModuleFactory {
    func makeContactsListController(viewModel: ContactsListViewModelType) -> ContactsListView
    func makeContactsDetailsController(viewModel: ContactsDetailsViewModelType) -> ContactsDetailsView
}

protocol FavoritesModuleFactory {
    func makeFavoritesView(viewModel: FavoritesViewModelType) -> FavoritesView
    func makeContactsDetailsController(viewModel: ContactsDetailsViewModelType) -> ContactsDetailsView
}
