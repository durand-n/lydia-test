//
//  UserDataManager.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//


import Foundation
import CoreData

class UserDataManager {
    var users: [User]?
    var container: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    func fetchUser() {
        users = getUsers()
    }

    
    /// CREATE
    func insertOne(_ remoteUser: RandomUsersApiModel.User) throws {
        let user = User(context: self.context)
        user.firstName = remoteUser.name.first
        user.lastName = remoteUser.name.last
        user.gender = 1
        self.context.insert(user)
        self.users?.append(user)
        try self.context.save()
    }
    
    // CREATE BATCH
    func insertMany(_ remoteUsers: [RandomUsersApiModel.User]) throws -> [User]? {
        remoteUsers.forEach { remoteUser in
            let user = User(context: self.context)
            user.firstName = remoteUser.name.first
            user.lastName = remoteUser.name.last
            user.gender = 1
            self.context.insert(user)
            self.users?.append(user)
        }
        try self.context.save()

        return self.users?.suffix(Constants.PAGINATION_NUMBER)
    }
    
    /// READ
    private func getUsers() -> [User]? {
        let data = try? self.context.fetch(User.createFetchRequest())
        if let users = data {
            return users
        } else {
            return nil
        }
    }
    
    /// DELETE
    public func drop() throws {
        try User.deleteAll(context: self.context)
    }
}
