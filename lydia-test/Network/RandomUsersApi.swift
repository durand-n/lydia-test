//
//  RandUsersApi.swift
//  lydia-test
//
//  Created by Benoît Durand on 16/10/2020.
//

import Foundation

enum RandomUsersApiRoutes {
    case Listing(page: UInt)
}

extension RandomUsersApiRoutes {
    var path: String {
        switch self {
        case .Listing(page: let page):
            return "https://randomuser.me/api/?results=\(Constants.PAGINATION_NUMBER)&seed=lydia&page=\(page)"
        }
    }
}

protocol RandomUsersApi {
    func getListing(page: UInt, completion: @escaping (_ items: RandomUsersApiModel.ApiResult? ,_ error: Error?) -> Void)
}

class RandomUsersApiImp: RandomUsersApi {

    func getListing(page: UInt, completion: @escaping (RandomUsersApiModel.ApiResult? ,Error?) -> Void) {
        if let url = URL(string: RandomUsersApiRoutes.Listing(page: page).path) {
            print("url: \(url)")
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let result = try decoder.decode(RandomUsersApiModel.ApiResult.self, from: data)
                        completion(result, error)
                    } catch let error {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
           }.resume()
        } else {
            completion(nil, nil)
        }
    }
}
