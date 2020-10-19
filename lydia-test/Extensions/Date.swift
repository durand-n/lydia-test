//
//  Date.swift
//  lydia-test
//
//  Created by Benoît Durand on 19/10/2020.
//

import Foundation

extension Date {
    public func string(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Calendar.current.locale
        formatter.timeZone = Calendar.current.timeZone
        return formatter.string(from: self)
    }
}
