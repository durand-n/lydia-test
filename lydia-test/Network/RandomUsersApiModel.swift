//
//  RandUsersApiModel.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//

import Foundation

class RandomUsersApiModel {
    
    struct ApiResult: Codable {
        var users: [User]
    
        private enum CodingKeys: String, CodingKey {
            case users = "results"
        }
    }
    
    struct User: Codable {
        let gender: String
        let name: Name
        let location: Location
        let email: String
        let dob: Dob
        let phone, cell: String
        let picture: Picture
        
    }
    
    // MARK: - Dob
    struct Dob: Codable {
        let date: Date
        let age: Int
    }


    // MARK: - Location
    struct Location: Codable {
        let street: Street
        let city: String
        let coordinates: Coordinates
    }
    
    // MARK: - Street
    struct Street: Codable {
        let number: Int
        let name: String
    }

    // MARK: - Coordinates
    struct Coordinates: Codable {
        let latitude, longitude: String
    }

    // MARK: - Name
    struct Name: Codable {
        let first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, thumbnail: String
    }
}

