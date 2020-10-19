//
//  UserDataManager.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//


import Foundation
import CoreData

enum Gender: String {
    case male
    case female
    
    func toInt16() -> Int16 {
        switch self {
        case .male:
            return 0
        case .female:
            return 1
        }
    }
    
    init?(value: Int16?) {
        guard let value = value, value <= 1, value >= 0 else { return nil }
        self = value == 0 ? .male : .female
    }
}

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
        user.email = remoteUser.email
        user.gender = Gender(rawValue: remoteUser.gender)?.toInt16() ?? 0
        user.age = Int16(remoteUser.dob.age)
        user.birthdate = remoteUser.dob.date
        user.cell = remoteUser.cell
        user.phone = remoteUser.phone
        user.city = remoteUser.location.city
        user.street = "\(remoteUser.location.street.number), " + remoteUser.location.street.name
        user.latitude = remoteUser.location.coordinates.latitude
        user.longitude = remoteUser.location.coordinates.longitude
        user.mediumPicture = remoteUser.picture.large
        user.thumbnail = remoteUser.picture.thumbnail
        user.isFavorite = false
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
            user.email = remoteUser.email
            user.gender = Gender(rawValue: remoteUser.gender)?.toInt16() ?? 0
            user.age = Int16(remoteUser.dob.age)
            user.birthdate = remoteUser.dob.date
            user.cell = remoteUser.cell
            user.phone = remoteUser.phone
            user.city = remoteUser.location.city
            user.street = "\(remoteUser.location.street.number), " + remoteUser.location.street.name
            user.latitude = remoteUser.location.coordinates.latitude
            user.longitude = remoteUser.location.coordinates.longitude
            user.mediumPicture = remoteUser.picture.large
            user.thumbnail = remoteUser.picture.thumbnail
            user.isFavorite = false
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
