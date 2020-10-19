//
//  lydia_testTests.swift
//  lydia-testTests
//
//  Created by Benoît Durand on 14/10/2020.
//

import XCTest
import CoreData
@testable import lydia_test

class DataManagerTests: XCTestCase {
    var userManager: UserDataManager!
    var dataManager: DataManager!
    
    override func setUp() {
        super.setUp()
        dataManager = DataManager(container: mockPersistantContainer)
        userManager = dataManager.userManager
        insertMock()
    }
    
    func testCreate() {
        userManager.fetchUser()
        XCTAssertEqual(dataManager.users?.count, 4)
        XCTAssertEqual(userManager.users?.count ?? 0, 4)
        _ = try? userManager.insertMany([])
        XCTAssertEqual(userManager.users?.count ?? 0, 4)
        try? userManager.insertOne(RandomUsersApiModel.User(gender: "male", name: RandomUsersApiModel.Name(first: "serge", last: "gainsbourg"), location: RandomUsersApiModel.Location(street: RandomUsersApiModel.Street(number: 12, name: "avenue des coquelicots"), city: "paris", coordinates: RandomUsersApiModel.Coordinates(latitude: "50.267906", longitude: "2.799245")), email: "serge@lydia.Fr", dob: RandomUsersApiModel.Dob(date: Date(), age: 15), phone: "0606060606", cell: "0101010101", picture: RandomUsersApiModel.Picture(large: "www.google.fr/large", thumbnail: "www.google.fr/small")))
        XCTAssertEqual(userManager.users?.count ?? 0, 5)
    }
    
    func testContactsListViewModel() {
        userManager.fetchUser()
        let vm = ContactsListViewModel(dataManager: dataManager)
        
        XCTAssertEqual(vm.userCount, 4)
    }
    
    override func tearDown() {
        flushData()
        super.tearDown()
    }
    
    func insertMock() {
        for i in 0...3 {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: mockPersistantContainer.viewContext)
            user.setValue("user\(i)", forKey: "firstName")
            user.setValue(i % 2, forKey: "gender")
            user.setValue("\(i)name", forKey: "lastName")
            user.setValue("\(i) street \(i*12)", forKey: "street")
            user.setValue("city N\(i)", forKey: "city")
            user.setValue("\(i).\(i * 8)", forKey: "latitude")
            user.setValue("-0.\(i)", forKey: "longitude")
            user.setValue("www.google.fr/\(i)/medium", forKey: "mediumPicture")
            user.setValue("www.google.fr/\(i)/thumb", forKey: "thumbnail")
            user.setValue(4*i, forKey: "age")
            user.setValue("01\(i)091010", forKey: "phone")
            user.setValue("07\(i)053110", forKey: "cell")
            user.setValue(Date(), forKey: "birthdate")
            user.setValue("test\(i)@gmail.com", forKey: "email")
        }
        
        do {
             try mockPersistantContainer.viewContext.save()
         }  catch {
             print("error \(error)")
         }
    }
    
    func flushData() {
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let objs = try! mockPersistantContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistantContainer.viewContext.delete(obj)
        }
        
        try! mockPersistantContainer.viewContext.save()
        
    }
    
    //MARK: mock in-memory persistant store
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObjectModel
    }()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
            
            let container = NSPersistentContainer(name: "lydia_test", managedObjectModel: self.managedObjectModel)
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false // Make it simpler in test env
            
            container.persistentStoreDescriptions = [description]
            container.loadPersistentStores { (description, error) in
                // Check if the data store is in memory
                precondition( description.type == NSInMemoryStoreType )

                // Check if creating container wrong
                if let error = error {
                    fatalError("Create an in-mem coordinator failed \(error)")
                }
            }
            return container
        }()
}
