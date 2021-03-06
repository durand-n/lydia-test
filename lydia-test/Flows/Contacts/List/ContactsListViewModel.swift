//
//  ContactsViewModel.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation

protocol ContactsListViewModelType {
    var onInsert: ((Int) -> Void)? { get set }
    var onDataLoaded: (() -> Void)? { get set }
    var onShowError: ((String) -> Void)? { get set }
    var userCount: Int { get }
    
    func dataFor(row: Int) -> ContactItemRepresentable?
    func userFor(row: Int) -> User?
    func fetchNextUsers()
    func startFetchingUsers()
}

class ContactsListViewModel: ContactsListViewModelType {
    
    // MARK - protocol compliance
    var onInsert: ((Int) -> Void)?
    var onDataLoaded: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
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
    
    func startFetchingUsers() {
        // If users count is enough to display full page of contacts, do nothing
        guard userCount < 20 else { return }
        Loader.show()
        dataManager.getFirstContacts { newUsers, error  in
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
        dataManager.getNextContacts { newUsers, error in
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
    
    func userFor(row: Int) -> User? {
        guard row < userCount else { return nil}
        return users[row]
    }
    
}

struct ContactItemRepresentable {
    var name: String
    var phone: String
    var mail: String
    var thumb: URL?
    var location: String
    
    init(contact: User) {
        name = contact.firstName + " " + contact.lastName
        mail = contact.email
        phone = contact.phone
        thumb = URL(string: contact.thumbnail)
        location = contact.city
    }
}
