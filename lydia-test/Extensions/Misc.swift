//
//  Misc.swift
//  lydia-test
//
//  Created by Benoît Durand on 15/10/2020.
//

import UIKit
import CoreData

extension Notification.Name {
    static let showOffline = Notification.Name("showOffline")
    static let hideOffline = Notification.Name("hideOffline")
}

extension NSManagedObject {
    static func deleteAll(context: NSManagedObjectContext) throws {
        try context.execute(NSBatchDeleteRequest(fetchRequest: self.fetchRequest()))
        try context.save()
    }
}

