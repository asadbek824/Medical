//
//  NetworkError.swift
//  NetworkManager
//
//  Created by Asadbek Yoldoshev on 23/04/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case incorrectStatusCode(Int)
}

