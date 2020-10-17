//
//  ContactsListViewModelType.swift
//  lydia-test
//
//  Created by Benoît Durand on 14/10/2020.
//

import UIKit

protocol ContactsListViewModelType {
    var onInsert: ((Int) -> Void)? { get set }
    var onDataLoaded: (() -> Void)? { get set }
    var onShowError: ((String) -> Void)? { get set }
    var userCount: Int { get }
    
    func dataFor(row: Int) -> ContactItemRepresentable?
    func fetchNextUsers()
    func startFetchingUsers()
}


