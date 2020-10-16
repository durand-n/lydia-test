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
        var gender: String
        var name: UserName
    }
    
    struct UserName: Codable {
        var title: String
        var first: String
        var last: String
    }

}

