//
//  ContactsDetailsViewModelType.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import Foundation
import CoreLocation
import ContactsUI

protocol ContactsDetailsViewModelType {
    var phoneNumber: String { get }
    var cellularNumber: String { get }
    var email: String { get }
    var isFavorite: Bool { get }
    
    func getData<T: ContactsDetailsRepresentable>() -> T
    func getContact() -> CNMutableContact
    func setAsFavorite(_ isFavorite: Bool)
}

class ContactsDetailsViewModel: ContactsDetailsViewModelType {
    private var user: User
    private var dataManager: DataManagerProtocol
    
    init(user: User, dataManager: DataManagerProtocol) {
        self.user = user
        self.dataManager = dataManager
    }
    
    
    // Protocol compliance
    
    var phoneNumber: String {
        return user.phone
    }
    
    var cellularNumber: String {
        return user.cell
    }
    
    var email: String {
        return user.email
    }
    
    var isFavorite: Bool {
        return user.isFavorite
    }
    
    func getData<T: ContactsDetailsRepresentable>() -> T {
        return T(self.user)
    }
    
    func getContact() -> CNMutableContact {
        let contact = CNMutableContact()
        
        contact.givenName = user.firstName
        contact.familyName = user.lastName
        contact.phoneNumbers = [CNLabeledValue(label: "Domicile", value: CNPhoneNumber(stringValue: user.phone)), CNLabeledValue(label: "Portable", value: CNPhoneNumber(stringValue: user.cell))]
        contact.emailAddresses = [CNLabeledValue(label: "personnel", value: user.email as NSString)]
        contact.note = "importé depuis Lydia-Test"
        return contact
    }
    
    func setAsFavorite(_ isFavorite: Bool) {
        user.isFavorite.toggle()
        dataManager.saveModifications()
    }
}

protocol ContactsDetailsRepresentable {
    init(_ user: User)
}

struct ContactIdentityRepresentable: ContactsDetailsRepresentable {
    var name: String
    var pictureUrl: URL?
    var birthDate: String
    
    init(_ user: User) {
        self.name = user.firstName + " " + user.lastName
        self.pictureUrl = URL(string: user.mediumPicture)
        self.birthDate = "\(user.age)ans - Né\(Gender(value: user.gender) == Gender.male ? "" : "e") le " + user.birthdate.string(withFormat: "dd/MM/yyyy")
    }
}

struct ContactSocialRepresentable: ContactsDetailsRepresentable {
    var cellular: String
    var phone: String
    var email: String
    
    init(_ user: User) {
        cellular = user.cell
        phone = user.phone
        email = user.email
    }
}

struct ContactLocationRepresentable: ContactsDetailsRepresentable {
    var street: String
    var city: String
    var location: CLLocationCoordinate2D?
    
    init(_ user: User) {
        street = user.street
        city = user.city
        if let lat = Double(user.latitude), let long = Double(user.longitude) {
            location = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
    }
}
