//
//  FavoritesViewModelType.swift
//  lydia-test
//
//  Created by Benoît Durand on 19/10/2020.
//

import Foundation

protocol FavoritesViewModelType {
    var userCount: Int { get }
    
    func dataFor(row: Int) -> FavoriteItemRepresentable?
    func userFor(row: Int) -> User?
    func refresh()
}

class FavoritesViewModel: FavoritesViewModelType {
   
    private var dataManager: DataManagerProtocol
    private var users: [User] {
        didSet {
            userCount = users.count
        }
    }
    
    init(dataManager: DataManagerProtocol) {
        self.users = dataManager.users ?? []
        self.userCount = self.users.count
        self.dataManager = dataManager
    }
    
    func refresh() {
        self.users = dataManager.users?.filter {
            $0.isFavorite == true
        } ?? []
    }
    
    var userCount: Int = 0
    
    func dataFor(row: Int) -> FavoriteItemRepresentable? {
        guard row < userCount else { return nil }
        return FavoriteItemRepresentable(contact: users[row])
    }
    
    func userFor(row: Int) -> User? {
        guard row < userCount else { return nil}
        return users[row]
    }
}

struct FavoriteItemRepresentable {
    var name: String

    var thumb: URL?
    
    init(contact: User) {
        name = contact.firstName
        thumb = URL(string: contact.mediumPicture)
    }
}
