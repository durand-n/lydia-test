//
//  ContactsViewModel.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation

class ContactsViewModel: ContactsListViewModelType {
    // MARK - protocol compliance
    var didInsert: ((Int) -> Void)?
    
    private var users: [User] {
        didSet {
            userCount = users.count
        }
    }
    
    init() {
        self.users = DataManager.shared.users ?? []
        self.userCount = self.users.count
    }
    
    func fetchNextUsers() {
        DataManager.shared.getNextContacts { (newUsers) in
            if let users = newUsers {
                self.users.append(contentsOf: users)
                self.didInsert?(users.count)
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
