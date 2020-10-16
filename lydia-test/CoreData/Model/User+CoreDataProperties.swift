//
//  User+CoreDataProperties.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var gender: Int16

}

extension User : Identifiable {

}
