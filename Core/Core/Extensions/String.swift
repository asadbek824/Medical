//
//  String.swift
//  Core
//
//  Created by Asadbek Yoldoshev on 15/05/24.
//

import Foundation

public extension String {
    var isNumber: Bool {
        CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    var code: Int {
        self.compactMap { char in
            char.wholeNumberValue
        }.reduce(0, +)
    }
    
    var nilIfEmpty: String? {
        self.isEmpty ? nil : self
    }
}

public extension String {
    var addDot: String {
        self + " "
    }
}
