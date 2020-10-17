//
//  ContactsViewModel.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation

class ContactsViewModel: ContactsListViewModelType {
    
    // MARK - protocol compliance
    var onInsert: ((Int) -> Void)?
    var onDataLoaded: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    private var users: [User] {
        didSet {
            userCount = users.count
        }
    }
    
    init() {
        self.users = DataManager.shared.users ?? []
        self.userCount = self.users.count
    }
    
    func startFetchingUsers() {
        // If users count is enough to display full page of contacts, do nothing
        guard userCount < 20 else { return }
        Loader.show()
        DataManager.shared.getFirstContacts { newUsers, error  in
            Loader.hide()
            if let users = newUsers {
                self.users.append(contentsOf: users)
                self.onDataLoaded?()
            } else {
                self.onShowError?("Une erreur est survenue, merci de réessayer plus tard")
            }
        }
    }
    
    func fetchNextUsers() {
        DataManager.shared.getNextContacts { newUsers, error in
            if let users = newUsers {
                self.users.append(contentsOf: users)
                self.onInsert?(users.count)
            } else {
                self.onShowError?("Une erreur est survenue, merci de réessayer plus tard")
            }
        }
    }
    
    var userCount: Int = 0
    
    func dataFor(row: Int) -> ContactItemRepresentable? {
        guard row < userCount else { return nil}
        return ContactItemRepresentable(contact: users[row])
    }
    
}

struct ContactItemRepresentable {
    var name: String
    
    init(contact: User) {
        name = contact.firstName + " " + contact.lastName
    }
}
