//
//  DataManager.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//

import Foundation
import CoreData

class DataManager {
    private var userManager: UserDataManager
    private var container: NSPersistentContainer
    private var index: UInt {
        didSet {
            UserDefaults.standard.set(index, forKey: Constants.CachedItems.lastPageLoaded.rawValue)
        }
    }
    
    static var shared = DataManager()
    private var api = RandomUsersApiImp()
    
    private init() {
        index = UserDefaults.standard.value(forKey: Constants.CachedItems.lastPageLoaded.rawValue) as? UInt ?? 1
        // Core Data initialisation
        container = NSPersistentContainer(name: "lydia_test")

        userManager = UserDataManager(container: container)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("unresolved error while loading container\(error)")
            } else {
                self.userManager.fetchUser()
            }
        }
        if index == 1 {
            //REMOVE ALL
        }
    }
    
    // MARK - CoreData methods
    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return self.container.viewContext
    }
    
    // MARK - public methods and properties
    
    func getNextContacts(completion: @escaping ([User]?) -> Void) {
        api.getListing(page: index) { (result, error) in
            if let users = result?.users {
                self.index += 1
                do {
                    let contacts = try self.userManager.insertMany(users)
                    completion(contacts)
                } catch {
                    print("An error occurred while creating users: \(error)")
                    completion(nil)
                }
            }
        }
    }
    
    func removeContacts() {
        try? self.userManager.drop()
    }
    
    var users: [User]? {
        return userManager.users
    }
}
