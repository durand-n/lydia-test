//
//  User+CoreDataProperties.swift
//  lydia-test
//
//  Created by Benoît Durand on 18/10/2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String
    @NSManaged public var gender: Int16
    @NSManaged public var lastName: String
    @NSManaged public var street: String
    @NSManaged public var city: String
    @NSManaged public var latitude: String
    @NSManaged public var longitude: String
    @NSManaged public var mediumPicture: String
    @NSManaged public var thumbnail: String
    @NSManaged public var age: Int16
    @NSManaged public var phone: String
    @NSManaged public var birthdate: Date
    @NSManaged public var email: String
    @NSManaged public var cell: String
    @NSManaged public var isFavorite: Bool

}
