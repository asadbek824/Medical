//
//  UserModel.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import Foundation

struct UserModel: Codable {
    let user: User?
    let confirmationCode: Int
    
}

struct User: Codable {
    let _id: String
    let fullName: String
    let email: String
    let isDoctor: Bool
}
