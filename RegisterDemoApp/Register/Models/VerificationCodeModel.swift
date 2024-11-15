//
//  VerificationCodeModel.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import Foundation

struct VerificationCodeModel: Codable {
    let user: User?
    let message: String
}
